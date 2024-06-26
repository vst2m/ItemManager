string pluginName = "Item Manager";
ItemManager@ manager = ItemManager();

bool showWindow = false;

void RenderMenu() {
    if (UI::MenuItem(pluginName)) {
        showWindow = !showWindow;
    }
}

void RenderInterface() {
    if (showWindow) {
        // show the item manager interface when the menu item is clicked, disable it when it is clicked again
        manager.RenderInterface();
    }
}