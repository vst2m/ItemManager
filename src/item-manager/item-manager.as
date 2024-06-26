// main class that manages everything
// gets constructed upon startup from data stored in the plugins storage folder
class ItemManager {

    string path;
    string indexUrl;
    ItemPack selectedPack;

    array<ItemPack@>@ packs = {};
    array<ItemPack@>@ installedPacks = {};

    ItemManager() {
        this.path = IO::FromStorageFolder("");

        // where the global index is stored containing all available packs for download with their version and a link to another index containing a download link for each file in the pack and their path
        this.indexUrl = "https://openplanet.dev/plugin/itemmanager/config/global-index";
        startnew(CoroutineFunc(ReadIndex));
    }

    // read the global index and store which packs are available
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
        ReadState();
        AutoUpdate();
    }

    // read the state of downloaded packs from the plugins storage folder
    private void ReadState() {
        if (IO::FileExists(path + "itempacks.json")) {
            Json::Value@ itemPacksArray = Json::FromFile(path + "itempacks.json");
            for (uint i = 0; i < itemPacksArray.Length; i++) {
                Json::Value@ packJson = itemPacksArray[i];
                ItemPack@ pack = ItemPack(string(packJson["name"]), string(packJson["author"]), string(packJson["version"]), string(packJson["url"]));
                installedPacks.InsertLast(pack);

                trace("Loaded pack: " + pack.name);
            }
        }
    }

    // save what packs are downloaded to the plugins storage folder
    private void SaveState() {
        if (IO::FileExists(path + "itempacks.json")) {
            IO::Delete(path + "itempacks.json");
        }
        Json::Value@ itemPacksArray = Json::Array();

        for (uint i = 0; i < installedPacks.Length; i++) {
            ItemPack@ pack = installedPacks[i];
            itemPacksArray.Add(pack.ToJson());
        }

        Json::ToFile(path + "itempacks.json", itemPacksArray);
    }

    // render the interface where you can download packs from.
    void RenderInterface() {
        UI::SetNextWindowSize(300, 150);
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

            if (UI::Button("Download")) {
                DownloadPack(selectedPack);
            }
        }
        UI::End();
    }

    // download a pack
    // gets called when the user clicks the download button
    private void DownloadPack(ItemPack@ pack) {
        pack.Download();
        installedPacks.InsertLast(pack);
        SaveState();
    }

    // delete a pack
    private void DeletePack(ItemPack@ pack) {
        pack.Delete();
        installedPacks.RemoveAt(installedPacks.Find(pack));
        SaveState();
    }

    // check for updates of downloaded packs upon trackmania boot
    private void AutoUpdate() {
        for (uint i = 0; i < installedPacks.Length; i++) {
            for (uint j = 0; j < packs.Length; j++) {
                ItemPack@ installedPack = installedPacks[i];
                ItemPack@ availablePack = packs[j];

                if (installedPack.name == availablePack.name && installedPack.author == availablePack.author && Text::ParseInt(availablePack.version) > Text::ParseInt(installedPack.version)) {
                    trace("Updating pack: " + availablePack.name);
                    DownloadPack(availablePack);
                    DeletePack(installedPack);
                }
            }
        }
    }
}
