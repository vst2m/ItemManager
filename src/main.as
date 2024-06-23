string pluginName = "Item Manager";
ItemManager@ manager = ItemManager();

bool showWindow = false;

void Main() {
}

void RenderMenu() {
    if (UI::MenuItem(pluginName)) {
        showWindow = !showWindow;
    }
}

void RenderInterface() {
    if (showWindow) {
        manager.RenderInterface();
    }
}