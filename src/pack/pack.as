class ItemPack {

    string name;
    string author;
    string version;
    string url;

    PathBuilder builder;

    private string path;
    private Mode mode;

    ItemPack() {}

    ItemPack(const string&in name, const string&in author, const string&in version, const string&in url) {
        this.name = name;
        this.author = author;
        this.version = version;
        this.url = url;

        this.mode = Mode::DO_NOTHING;
        this.path = IO::FromUserGameFolder("items/" + name + "/");
    }

    void SetMode(Mode mode) {
        this.mode = mode;
    }

    void Download() {
        startnew(CoroutineFunc(this.DownloadAsync));
    }

    void Delete() {
        IO::DeleteFolder(path, true);
    }

    void DownloadAsync() {

        if (mode == Mode::OVERRIDE) {
            // delete all items in the user's items folder
            array<string> userItems = IO::IndexFolder(path, false);
            for (uint i = 0; i < userItems.Length; i++) {
                // TODO
                print(userItems[i]);
            }
        }

        Net::HttpRequest@ request = Net::HttpGet(url);
        while (!request.Finished()) {
            yield();
        }

        Json::Value@ index = request.Json();
        for (uint i = 0; i < index.Length; i++) {

            Json::Value@ item = index[i];
            Net::HttpRequest@ itemRequest = Net::HttpGet(item["url"]);

            while (!itemRequest.Finished()) {
                yield();
            }

            string itemPath = path + string(item["path"]);
            builder.BuildPath(itemPath);
            itemRequest.SaveToFile(itemPath);
            trace("Saved item: " + itemPath);
        }
    }

    bool opEquals(ItemPack@ pack) {
        return pack.name == this.name && pack.author == this.author && pack.version == this.version;
    }

    Json::Value@ ToJson() {
        Json::Value@ itemPackJson = Json::Object();
        itemPackJson["name"] = name;
        itemPackJson["author"] = author;
        itemPackJson["version"] = version;
        itemPackJson["url"] = url;
        return itemPackJson;
    }

}

class MacroBlockPack {
    // TODO
}
