// Put all the javascript code here, that you want to execute in background.

var port = browser.runtime.connectNative("test_activity");

browser.tabs.onCreated.addListener(onTabCreated);
port.onMessage.addListener(onMessage);

function onTabCreated(tab) {
	//setTimeout( () => {
		//browser.windows.create({tabId: tab.id});
	//}, 3000);
	port.postMessage( { "tabid": tab.id
					  , "windowid": tab.windowId
					  }
					);
}

function onMessage(message) {
	setTimeout(() => {
		browser.windows.create({tabId: message.tabid});
	}, 3000);
}
