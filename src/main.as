Mode overrideItems = Mode::DO_NOTHING;
string version = "11.0";
string pluginName = "Ski Pack Manager";
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

    // for testing purposes
    if (Debug) {
        Test::RenderTestInterface();
    }
}