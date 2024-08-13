from typing import List, Dict, Pattern, Match, Tuple
from typing import Union, ClassVar, Optional, cast, TypeVar, TextIO
import string
from . import libzpp

from PIL import Image
import re
import io
import base64
import os.path

# [
#      {
#          "type": "text"
#          "text": str
#      }, # or
#      {
#          "type": "image_url"
#          "image_url": {
#              "url": str
#          }
#      },
#      {
#          "type": "image"
#          "image": Image.Image
#      }
#      ...
# ]
VisionMessage = List[Dict[str, Union[str, Dict[str, str], Image.Image]]]
GeneralMessage = Union[str, VisionMessage]

def split_mapping_dict(mapping: Dict[str, Union[str, Image.Image]])\
        -> Tuple[Dict[str, str], Dict[Optional[str], Image.Image]]:
    #  function split_mapping_dict {{{ # 
    """
    Splits a mapping dict into text mapping dict and image mapping dict.
    """

    text_mapping: Dict[str, str] = {}
    img_mapping: Dict[Optional[str], Image.Image] = {}
    for k, val in mapping.items():
        if k.startswith("image_"):
            img_mapping[k[6:]] = val
        elif k == "image":
            img_mapping[None] = val
        else:
            text_mapping[k] = val
    return text_mapping, img_mapping
    #  }}} function split_mapping_dict # 

class VisionTemplate():
    #  Class VisionTemplate {{{ # 
    _image_regex: ClassVar[Pattern[str]] = re.compile( r""" \$\{?image(?:_(?P<imgid>[_a-z0-9]*))?\b\}? # image id
                                                          | \$\{
                                                            imagef:(?P<imgf>[^:}]+) # constant image file name
                                                            (?::(?P<w>\d+):(?P<h>\d+))? # optional resize to wxh
                                                            \}
                                                        """
                                                     , re.ASCII | re.VERBOSE
                                                     )

    def __init__(self, prompt_str: str):
        #  method __init__ {{{ # 
        """
        Args:
            prompt_str (str): prompt string following the syntax of
              string.Template. the placeholder like "${image_*}" or
              "${imagef:path:w:h}" will be handled specially by replacing it with
              an image instance
        """

        self._template: string.Template = string.Template(prompt_str)
        #  }}} method __init__ # 

    def safe_substitute( self
                       , text_mapping: Optional[Dict[str, str]] = None
                       , img_mapping: Optional[Dict[Optional[str], Image.Image]] = None
                       , wrap_pure_text: bool = False
                       , to_base64: bool = True
                       , fidelity_option: Dict[str, str] = {}
                       ) -> GeneralMessage:
        #  method safe_substitute {{{ # 
        """
        Args:
            text_mapping (Optional[Dict[str, str]]): mapping of the
              textual placeholders.
            img_mapping (Optional[Dict[Optional[str], Image.Image]]): mapping
              of the vision placeholders. the placeholders are like "image" or
              "image_xxx". however, the keys should be provided as the part
              after "image_", i.e. "xxx". the key for placeholder "image" is
              `None`.

            wrap_pure_text (bool): if wraps pure text with list of dict like
              {
                "type": "text"
                "text": str
              }
            to_base64 (bool): whether to convert the input image to base64 or
              keep it as Image.Image.
            fidelity_option (Dict[str, str]): fidelity option for image
              instances like "low", "high", or "auto"; if specifying, share the
              keys in img_mapping; for ${image_f:file_name} slots, use
              "f:file_name" as keys.

        Returns:
            Union[str, VisionMessage]: the substituted message; str for pure
              texts and VisionMessage for visual-text message
        """

        mapping: Dict[Optional[str], str] = text_mapping or {}
        for k in list( filter( lambda k: k.startswith("image_") or k=="image"
                             , mapping.keys()
                             )
                     ):
            del mapping[k]
        prompt: str = self._template.safe_substitute(mapping)

        message: VisionMessage = []
        splits: List[Optional[str]] = VisionTemplate._image_regex.split(prompt)

        if len(splits)==1:
            return prompt if not wrap_pure_text\
                        else [ { "type": "text"
                               , "text": prompt
                               }
                             ]

        step = 5
        for t, img_id, img_f, img_w, img_h in\
                zip( splits[0:len(splits)-1:step]
                   , splits[1::step]
                   , splits[2::step]
                   , splits[3::step]
                   , splits[4::step]
                   ):
            if len(t)>0:
                message.append({"type": "text", "text": t})
            if img_f is None and img_id in img_mapping:
                img_obj: Optional[Image.Image] = img_mapping[img_id]
                fidelity: Optional[str] = fidelity_option.get(img_id, None)
            elif img_f is not None:
                img_obj: Optional[Image.Image] = Image.open(img_f)
                if img_w is not None and img_h is not None:
                    img_obj = img_obj.resize((int(img_w), int(img_h)))
                fidelity: Optional[str] = fidelity_option.get("f:" + img_f, None)
            else:
                img_obj: Optional[Image.Image] = None

            if img_obj is not None:
                img_obj: Image.Image = cast(Image.Image, img_obj)

                if to_base64:
                    if img_obj.mode=="RGBA":
                        mode: str = "png"
                    else:
                        mode: str = "jpeg"
                    with io.BytesIO() as bff:
                        img_obj.save(bff, mode)
                        img_data: bytes = bff.getvalue()

                    segment = { "type": "image_url"
                              , "image_url": {
                                  "url": "data:image/{:};base64,".format(mode)\
                                       + base64.b64encode(img_data).decode()
                                }
                              }
                    if fidelity is not None:
                        segment["image_url"]["detail"] = fidelity
                    message.append(segment)

                else:
                    message.append( { "type": "image"
                                    , "image": img_obj
                                    }
                                  )
        if len(splits[-1])>0:
            message.append({"type": "text", "text": splits[-1]})
        return message
        #  }}} method safe_substitute # 

    @property
    def template(self) -> str:
        return self._template.template

    def __str__(self) -> str:
        return self.template
    #  }}} Class VisionTemplate # 

# {
#   "role": "system" | "user" | "assistant" | ""
#   "content": M
# }
M = TypeVar("Message")
MessageGroupT = List[Dict[str, Union[str, M]]]
TemplateGroupT = MessageGroupT[VisionTemplate]
PromptGroupT = MessageGroupT[GeneralMessage]

class TemplateGroup:
    #  class TemplateGroup {{{ # 
    _slot_regex: ClassVar[Pattern[str]] =\
            re.compile( r""" (?P<cpref>(?:^|[^$])(?:\$\$)*) # handle with escaped $
                             (?: (?P<imgfpref>\$\{imagef:) # image file leading
                                 (?P<imgfn>[^:}]+) # image file name
                                 (?P<imgfsuff>(?::(?:\d+):(?:\d+))?\}) # resizing
                               | (?P<prefix>\$\{?)(?P<slotid>[_a-z0-9]+\b)(?P<suffix>\}?) # slot/image id
                               )
                         """
                      , re.ASCII | re.VERBOSE
                      )

    def __init__( self
                , templates: TemplateGroupT, style: str = "chat"
                , snippets: Dict[str, str] = {}
                , default_text_mappings: Optional[Dict[str, str]] = None
                , default_img_mappings: Optional[Dict[str, Image.Image]] = None
                ):
        #  method __init__ {{{ # 
        self._templates: TemplateGroupT = templates
        self._style: str = style
        self._snippets: Dict[str, str] = snippets
        self._default_text_mappings: Dict[str, str] = default_text_mappings or {}
        self._default_img_mappings: Dict[str, str] = default_img_mappings or {}
        #  }}} method __init__ # 

    def safe_substitute( self
                       , text_mapping: Optional[Dict[str, str]] = None
                       , img_mapping: Optional[Dict[Optional[str], Image.Image]] = None
                       , style: Optional[str] = None
                       , pure_text: bool = False
                       , wrap_pure_text: bool = False
                       , to_base64: bool = True
                       , fidelity_option: Dict[str, str] = {}
                       , strip_white_spaces: bool = False
                       , squeeze_empty: bool = True
                       ) -> Union[PromptGroupT, List[GeneralMessage]]:
        #  method safe_substitute {{{ # 
        """
        Args:
            text_mapping (Optional[Dict[str, str]]): mapping of the
              textual placeholders.
            img_mapping (Optional[Dict[Optional[str], Image.Image]]): mapping
              of the vision placeholders. the placeholders are like "image" or
              "image_xxx". however, the keys should be provided as the part
              after "image_", i.e. "xxx". the key for placeholder "image" is
              `None`.

            style (Optional[str]): "chat" | "instruct", defaults to self._style
            pure_text (bool): if keeps only text sections
            wrap_pure_text (bool): if wraps text sections with list of dict
              like
                {
                    "type": "text"
                    "text": str
                }
            to_base64 (bool): whether to convert the input image to base64 or
              keep it as Image.Image.
            fidelity_option (Dict[str, str]): fidelity option for image
              instances like "low", "high", or "auto"; if specifying, share the
              keys in img_mapping; for ${image_f:file_name} slots, use
              "f:file_name" as keys.

            strip_white_spaces (bool): if the leading and trailing white spaces
              are to stripped
            squeeze_empty (bool): if the empty segments/messages should be
              removed

        Returns:
            Union[PromptGroupT, GeneralMessage]: instantiated
              template
        """

        text_mapping = text_mapping or {}
        for k, val in self._default_text_mappings.items():
            text_mapping.setdefault(k, val)
        img_mapping = img_mapping or {}
        for k, val in self._default_img_mappings.items():
            img_mapping.setdefault(k, val)

        style: str = style or self._style

        messages: PromptGroupT = []
        for tmpl in self._templates:
            content: GeneralMessage = tmpl["content"]\
                                        .safe_substitute( text_mapping=text_mapping
                                                        , img_mapping=img_mapping
                                                        , wrap_pure_text=wrap_pure_text
                                                        , to_base64=to_base64
                                                        , fidelity_option=fidelity_option
                                                        )
            if pure_text and isinstance(content, list):
                content_strs: List[str] =\
                        [sct["text"] for sct in content if sct["type"]=="text"]
                content: str = " ".join(content_strs)
            if wrap_pure_text and isinstance(content, str):
                content: VisionMessage = [ { "type": "text"
                                           , "text": content
                                           }
                                         ]
            if strip_white_spaces:
                if isinstance(content, str):
                    content: str = content.strip()
                else:
                    for sgm in content:
                        if sgm["type"]=="text":
                            sgm["text"] = sgm["text"].strip()
            if squeeze_empty:
                if isinstance(content, list):
                    content: VisionMessage = [sgm for sgm in content if sgm["type"]!="text" or len(sgm["text"])>0]
                if len(content)==0:
                    continue
            messages.append( { "role": tmpl["role"] or "user"
                             , "content": content
                             }
                           )
        if style=="chat":
            return messages
        elif style=="instruct":
            messages: List[GeneralMessage] = [m["content"] for m in messages]
            return messages
        raise NotImplementedError()
        #  }}} method safe_substitute # 

    def snippet(self, snippet_id: str) -> str:
        return self._snippets.get(snippet_id, "")

    @classmethod
    def instantiate_snippet( cls, snippet: str, slot_id_suffix: str
                           , default_values: Dict[str, str] = None
                           , default_images: Dict[str, Image.Image] = None
                           ) -> str:
        #  method instantiate_snippet {{{ # 
        """
        This functions will update default_values.
        """

        if default_values is None:
            default_values = {}
        if default_images is None:
            default_images = {}

        def replacer(m: Match[str]) -> str:
            if m.group("imgfpref") is not None:
                main_name: str
                ext_name: str
                main_name, ext_name = os.path.splitext(m.group("imgfn"))
                return "{:}{:}{:}_{:}{:}{:}"\
                            .format( m.group("cpref")
                                   , m.group("imgfpref")
                                   , main_name
                                   , slot_id_suffix
                                   , ext_name
                                   , m.group("imgfsuff")
                                   )
            else:
                new_slot_id: str = "{:}_{:}".format(m.group("slotid"), slot_id_suffix)
                if m.group("slotid") in default_values and new_slot_id not in default_values:
                    default_values[new_slot_id] = default_values[m.group("slotid")]
                elif m.group("slotid").startswith("image_")\
                        and m.group("slotid")[6:] in default_images\
                        and new_slot_id[6:] not in default_images:
                    default_images[new_slot_id[6:]] = default_images[m.group("slotid")[6:]]
                return "{:}{:}{:}{:}"\
                            .format( m.group("cpref")
                                   , m.group("prefix")
                                   , new_slot_id
                                   , m.group("suffix")
                                   )
        snippet_text: str = cls._slot_regex.sub(replacer, snippet)
        return snippet_text
        #  }}} method instantiate_snippet # 

    @classmethod
    def parse( cls, template_file: str
             , flag_macros: Optional[List[str]] = None
             , value_macros: Optional[Dict[str, str]] = None
             ) -> "TemplateGroup":
        #  method parse {{{ # 
        #  Preprocess with zpp {{{ # 
        flag_macros = flag_macros or []
        value_macros = value_macros or {}
        for mcr in flag_macros:
            if mcr not in value_macros:
                value_macros[mcr] = ""
            
        preprocessed_file: TextIO = io.StringIO()
        config_dict: Dict[str, str] = libzpp.MODE_DICT["T"]
        config_dict["path"] = os.path.dirname(template_file)
        with open(template_file) as f:
            libzpp.preprocess( f, preprocessed_file
                             , configs=config_dict
                             , states={"macros": value_macros}
                             )
        #  }}} Preprocess with zpp # 

        style: str = "chat"

        recording: bool = False
        templates: TemplateGroupT = []
        current_template_strs: List[str] = []
        current_role: str = ""

        recording_snippet: bool = False
        snippets: Dict[str, str] = {}
        current_snippet_strs: List[str] = []
        current_snippet_name: str = ""

        recording_value: bool = False
        default_values: Dict[str, str] = {}
        default_images: Dict[str, Image.Image] = {}
        current_value_strs: List[str] = []
        current_value_name: str = ""

        preprocessed_file.seek(0)
        for l in preprocessed_file:
            if l.startswith("% "): # comment
                pass
            elif l.startswith("%%%"): # meta
                style = l[3:].strip()
            elif l.startswith("---"): # role
                if recording:
                    templates.append(
                            { "role": current_role
                            , "content": VisionTemplate("".join(current_template_strs))
                            }
                          )
                current_role: str = l[3:].strip()
                recording = True
                current_template_strs = []

            elif l.startswith("``` "): # snippet def
                current_snippet_name = l[4:].strip()
                recording_snippet = True
                current_snippet_strs = []
            elif l.strip()==("```"): # snippet def end
                snippets[current_snippet_name] = "".join(current_snippet_strs)
                recording_snippet = False
            elif l.startswith("### "): # value def
                current_value_name = l[4:].strip()
                recording_value = True
                current_value_strs = []
            elif l.strip()==("###"): # value def end
                if current_value_name.startswith("image_"):
                    # "${imagef:xxx:w:h}"
                    image_file_definition: List[str] = current_value_strs[0].strip()[9:-1].rsplit(":", maxsplit=2)
                    image_file_name: str = image_file_definition[0]
                    img_obj: Image.Image = Image.open(image_file_name)
                    if len(image_file_definition)>=3:
                        width: int = int(image_file_definition[1])
                        height: int = int(image_file_definition[2])
                        img_obj = img_obj.resize((width, height))
                    default_images[current_value_name[6:]] = img_obj
                else:
                    default_values[current_value_name] = "".join(current_value_strs)[:-1]
                recording_value = False
            elif l.startswith("=== "): # snippet invocation
                fields: List[str] = l.strip().split()
                snippet_name: str = fields[1]
                slot_id_suffix: str = fields[2]

                snippet_text = cls.instantiate_snippet( snippets[snippet_name]
                                                      , slot_id_suffix
                                                      , default_values
                                                      , default_images
                                                      )
                if recording_value:
                    current_value_strs.append(snippet_text)
                elif recording_snippet:
                    current_snippet_strs.append(snippet_text)
                elif recording:
                    current_template_strs.append(snippet_text)
            elif l.startswith("\\\\\\"): # escaping
                literal_line: str = l[3:]
                if recording_value:
                    current_value_strs.append(literal_line)
                elif recording_snippet:
                    current_snippet_strs.append(literal_line)
                elif recording:
                    current_template_strs.append(literal_line)
            else: # plain texts
                if recording_value:
                    current_value_strs.append(l)
                elif recording_snippet:
                    current_snippet_strs.append(l)
                elif recording:
                    current_template_strs.append(l)
        if recording:
            templates.append(
                    { "role": current_role
                    , "content": VisionTemplate("".join(current_template_strs))
                    }
                  )
        return cls( templates, style=style, snippets=snippets
                  , default_text_mappings=default_values
                  , default_img_mappings=default_images
                  )
        #  }}} method parse # 

    def __str__(self) -> str:
        #  method __str__ {{{ # 
        lines: List[str] = []
        lines.append("%%% {:}\n".format(self._style))
        for tmpl in self._templates:
            lines.append("---{:}\n".format(tmpl["role"]))
            lines.append(tmpl["content"].template)
        return "".join(lines)
        #  }}} method __str__ # 

    @staticmethod
    def escape_prompt(prompt: str) -> str:
        #  function escape_prompt {{{ # 
        escaped_lines: List[str] = []
        for l in prompt.splitlines():
            if l.startswith("% ")\
                    or l[:3] in { "%%%", "---", "\\\\\\"
                                , "```", "###", "==="
                                }:
                escaped_lines.append("\\\\\\" + l)
            else:
                escaped_lines.append(l)
        return "\n".join(escaped_lines)
        #  }}} function escape_prompt # 
    #  }}} class TemplateGroup # 

def display_vision_message(message: VisionMessage) -> str:
    #  function display_vision_message {{{ # 
    lines: List[str] = []
    for sct in message:
        if sct["type"]=="text":
            lines.append(sct["text"])
        elif sct["type"]=="image_url": # {{{
            lines.append("${{image:{:}}}".format(sct["image_url"]["url"][:30] + "..."))
        elif sct["type"]=="image": # {{{
            lines.append( "${{image:{:}_{:}_{:}x{:}}}".format( sct["image"].filename
                                                             , sct["image"].mode
                                                             , sct["image"].width
                                                             , sct["image"].height
                                                             )
                        )
    return "".join(lines)
    #  }}} function display_vision_message # 

def display_prompt_group(prompt: PromptGroupT) -> str:
    #  function display_prompt_group {{{ # 
    lines: List[str] = []
    for msg in prompt:
        lines.append("---{:}\n".format(msg["role"]))
        if isinstance(msg["content"], str):
            lines.append(msg["content"])
        else:
            lines.append(display_vision_message(msg["content"]))
    return "".join(lines)
    #  }}} function display_prompt_group # 
