// Put all the javascript code here, that you want to execute in background.

//var port = browser.runtime.connectNative("test_activity");

var on = true;

browser.tabs.onCreated.addListener(onTabCreated);
//port.onMessage.addListener(onMessage);
browser.browserAction.onClicked.addListener(() => {on = false;})

function onTabCreated(tab) {
	console.log(on);
	setTimeout( () => {
		//browser.windows.create({tabId: tab.id});
		checkFocused(tab);
	}, 3000);
	//console.log("onTabCreated");
	//let respone = browser.runtime.sendNativeMessage( "test_activity"
									 			   //, { "tabid": tab.id
									 			     //, "windowid": tab.windowId
									 			     //}
									 			   //);
	//respone.then(onMessage);
}

async function checkFocused(tab) {
	if(on) {
		let windowList = await browser.windows.getAll();
		if(windowList.every((elm) => {return !elm.focused;}))
			browser.windows.create({tabId: tab.id});
	}
}

function onMessage(message) {
	//console.log("onMessage");
	browser.windows.create({tabId: message.tabid});
}
