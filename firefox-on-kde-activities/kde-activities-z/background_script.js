// Put all the javascript code here, that you want to execute in background.

var on = true;

browser.tabs.onCreated.addListener(onTabCreated);
browser.browserAction.onClicked.addListener(() => {
	on = !on;
	browser.browserAction.setIcon( { "path": { 64:
												on
											  ? "icons/iconz.png"
											  : "icons/icong.png"
											 }
								   }
								 );
});

async function onTabCreated(tab) {
	if(on) {
		console.log("onTabCreated");
		let window_list = await browser.windows.getAll();
		window_id_list = window_list.map((elm) => {
			return elm.id;
		});
		window_title_list = window_list.map((elm) => {
			return elm.title;
		});
		message = { "tid": tab.id
				  , "wid": tab.windowId
				  , "wlist": window_id_list
				  , "tlist": window_title_list
				  }
		console.log(message.tid);
		console.log(message.wlist);
		console.log(message.tlist);
		let response = await browser.runtime.sendNativeMessage( "test_activity"
														      , message
														      );
		onMessage(response);
	}
}

function onMessage(message) {
	console.log("onMessage");
	console.log(message.act);
	if(message.act=="new") {
		browser.windows.create({tabId: message.tid});
	}
	else if(message.act=="move") {
		browser.tabs.move( message.tid
						 , { windowId: message.wid
						   , index: -1
						   }
						 )
					.then( (tab) => {
							browser.tabs.update( tab.id
											   , { active: true
												 }
											   );
						  }
					     );
	}
}
