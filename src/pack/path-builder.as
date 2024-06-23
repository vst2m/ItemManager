class PathBuilder {

    PathBuilder() {
    }

    // code from Dips++ - thanks to XertroV!
    void BuildPath(const string&in path) {

        auto parts = path.Split("/");
        auto fileName = parts[parts.Length - 1];
        parts.RemoveLast();
        auto dir = string::Join(parts, "/");
        trace("Checking destination dir: " + dir);

        if (!IO::FileExists(dir) && !IO::FolderExists(dir)) {
            // create all directories up to the file, then a directory with the name of the file
            IO::CreateFolder(dir, true);
            trace("Created folder: " + dir);
        }
    }
}