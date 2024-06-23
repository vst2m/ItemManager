class Item {
    string path;
    string url;

    Item(const string&in path, const string&in url) {
        this.path = path;
        this.url = url;
    }

    string ToString() {
        return"\npath: " + path + "\nurl: " + url;
    }
};
