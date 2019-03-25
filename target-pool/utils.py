def splitline(line):
    """
    return target, a number
    """
    line = line.strip()
    item = line.rsplit(maxsplit=1)
    if len(item)>=2:
        try:
            weight = max(1,int(item[-1]))
            target = item[0]
        except ValueError:
            weight = 1
            target = line
    else:
        target = line
        weight = 1
    return target,weight
