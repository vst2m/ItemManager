// represents an itempack
class ItemPack {

    string name;
    string author;
    string version;
    string url;

    PathBuilder builder;

    private string path;


    ItemPack() {}

    ItemPack(const string&in name, const string&in author, const string&in version, const string&in url) {
        this.name = name;
        this.author = author;
        this.version = version;
        this.url = url;

        this.path = IO::FromUserGameFolder("items/" + name + "/");
    }

    void Download() {
        startnew(CoroutineFunc(this.DownloadAsync));
    }

    void Delete() {
        IO::DeleteFolder(path, true);
    }

    // download this pack asynchronously to Trackmania/Items/[pack name]
    // this is done by requesting each download link for each file and saving them to the path specified in the json object
    void DownloadAsync() {

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

    // packs are the same when their name, author and version is the same. the index url does not matter
    bool opEquals(ItemPack@ pack) {
        return pack.name == this.name && pack.author == this.author && pack.version == this.version;
    }

    // returns a json object representation for the pack
    // is used when saving the current state of downloaded packs in ItemManager
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
