// utility class for building a file path in a certain directory
// thanks to XertroV for contributing this code from Dips++!
class PathBuilder {

    PathBuilder() {
    }

    void BuildPath(const string&in path) {

        auto parts = path.Split("/");
        auto fileName = parts[parts.Length - 1];
        parts.RemoveLast();
        auto dir = string::Join(parts, "/");
        trace("Checking destination dir: " + dir);

        if (!IO::FileExists(dir) && !IO::FolderExists(dir)) {
            IO::CreateFolder(dir, true);
            trace("Created folder: " + dir);
        }
    }
}
