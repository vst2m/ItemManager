enum Mode {
    DO_NOTHING,
    OVERRIDE,
    MOVE,
    XXX_Last
}

namespace ModeToString {
    string modeName(Mode mode) {
        if (mode == Mode::DO_NOTHING) {
            return "Do nothing";
        } else if (mode == Mode::OVERRIDE) {
            return "Override";
        } else if (mode == Mode::MOVE) {
            return "Move";
        } else {
            error("Unknown mode");
            return "";
        }
    }

    string modeDescription(Mode mode) {
        if (mode == Mode::DO_NOTHING) {
            return "leaves the existing item files in their place";
        } else if (mode == Mode::OVERRIDE) {
            return "removes all existing item files before installing an item pack";
        } else if (mode == Mode::MOVE) {
            return "moves the existing item files to a user-specified directory";
        } else {
            error("Unknown mode");
            return "";
        }
    }
}
