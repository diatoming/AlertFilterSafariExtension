// Wait for the DOM to load before dispatching a message to the app extension's Swift code.
document.addEventListener("DOMContentLoaded", function(event) {
    safari.extension.dispatchMessage("docLoaded");
});

// Listens for messages sent from the app extension's Swift code.
safari.self.addEventListener("message", handleMessage);

var config = null;

document.addEventListener('click', function(event) {

    var anchor = event.target.closest("a"); // Find closest Anchor (or self)
	if (anchor == null) return;

	var scheme = anchor.protocol;
    scheme = scheme.replace(":", "");

    if (!shouldHandleLink(scheme)) {
        return true;
    }
    event.preventDefault();
    linkClicked(event, anchor.href);
}, true);

function linkClicked(e, url) {
    safari.extension.dispatchMessage("handleCustomScheme", {
        "url": url
    });
}

function shouldHandleLink(scheme) {
    var list = config["schemeList"];
    return list.indexOf(scheme) > -1;
}

function handleMessage(event) {
    switch (event.name) {
        case "extensionSettingsUpdated":
            var dict = event.message;
            config = dict;
            break;
    }
}
