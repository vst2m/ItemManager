Mode overrideItems = Mode::DO_NOTHING;
string version = "11.0";
string pluginName = "Item Manager";
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
        ItemManager::RenderItemManagerInterface();
    }
}