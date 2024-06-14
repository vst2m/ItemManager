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
        RenderItemManagerInterface();
    }

    // for testing purposes
    Test::RenderTestInterface();
}

void RenderItemManagerInterface() {
    if (UI::Begin(pluginName)) {
        // download options
        // TODO: get from github api and download from there
        if (UI::BeginCombo("Version", version)) {
            if (UI::Selectable(version, true)) {

            }
            UI::EndCombo();
        }

        // setting for choosing a mode
        if (UI::BeginCombo("Existing items", ModeToString::modeName(overrideItems))) {
            for (int i = 0; i < int(Mode::XXX_Last); i++) {
                Mode mode = Mode(i);
                if (UI::Selectable(ModeToString::modeName(mode), mode == overrideItems)) {
                    overrideItems = mode;
                }
            }
            UI::EndCombo();
        }
        UI::Text(ModeToString::modeDescription(overrideItems));
        
        // download button
        if (UI::Button("Download")) {
            DownloadPack();
            print("TODO: download files");
        }
    }
    UI::End();
}

void DownloadPack() {

    // TODO
}
