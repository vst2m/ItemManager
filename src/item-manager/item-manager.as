class ItemManager {

    string indexUrl;
    ItemPack selectedPack;
    Mode selectedMode;

    array<ItemPack@>@ packs = {};

    ModeStringConverter modeStringConverter;

    ItemManager() {
        this.indexUrl = "https://openplanet.dev/plugin/itemmanager/config/global-index";
        this.selectedMode = Mode::DO_NOTHING;
        startnew(CoroutineFunc(this.ReadIndex));
    }

    void ReadIndex() {
        Net::HttpRequest@ indexRequest = Net::HttpGet(indexUrl);
        while (!indexRequest.Finished()) {
            yield();
        }

        Json::Value@ globalIndex = indexRequest.Json();
        for (uint i = 0; i < globalIndex.Length; i++) {
            Json::Value@ packJson = globalIndex[i];
            ItemPack@ indexPack = ItemPack(packJson["name"], packJson["author"], packJson["version"], packJson["url"]);
            packs.InsertLast(indexPack);
        }

        this.selectedPack = packs[0];
    }   

    void RenderInterface() {
        if (UI::Begin(pluginName)) {
            if (UI::BeginCombo("Pack", selectedPack.name)) {
                for (int i = 0; i < packs.Length; i++) {
                    ItemPack@ pack = packs[i];
                    // TODO equals defenition for packs
                    if (UI::Selectable(pack.name, selectedPack.name == pack.name)) {
                        selectedPack = pack;
                    }
                }
                UI::EndCombo();
            }

            if (UI::BeginCombo("Existing items", modeStringConverter.Name(selectedMode))) {
                for (int i = 0; i < int(Mode::XXX_Last); i++) {
                    Mode mode = Mode(i);
                    if (UI::Selectable(modeStringConverter.Name(mode), mode == selectedMode)) {
                        selectedMode = mode;
                    }
                }
                UI::EndCombo();
            }

            if (UI::Button("Download")) {
                selectedPack.Download();
            }
        }
        UI::End();
    }
}
