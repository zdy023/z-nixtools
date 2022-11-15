// Put all the javascript code here, that you want to execute in background.

//var port = browser.runtime.connectNative("test_activity");

browser.tabs.onCreated.addListener(onTabCreated);
//port.onMessage.addListener(onMessage);

function onTabCreated(tab) {
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
	let windowList = await browser.windows.getAll();
	if(windowList.every((elm) => {return !elm.focused;}))
		browser.windows.create({tabId: tab.id});
}

function onMessage(message) {
	//console.log("onMessage");
	browser.windows.create({tabId: message.tabid});
}
