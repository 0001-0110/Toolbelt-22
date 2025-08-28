from collections import namedtuple
import json
import sys
import os


class Version:

    @staticmethod
    def parse(version):
        if version is None:
            return None
        return Version(*map(int, version.split(".")))

    def __init__(self, major, minor, patch):
        self.major = major
        self.minor = minor
        self.patch = patch

    def __gt__(self, other):
        if self.major > other.major:
            return True
        if self.major == other.major and self.minor > other.minor:
            return True
        if self.major == other.major and self.minor == other.minor and self.patch > other.patch:
            return True
        return False

    def __str__(self):
        return f"{self.major}.{self.minor}.{self.patch}"

def get_argv(i):
    return sys.argv[i] if len(sys.argv) > i else None

def validate_info():
    try:
        with open("info.json") as file:
            content = json.load(file)
    except:
        print("Could not find info.json")
        return False

    required_fields = [
        "name",
        "version",
        "title",
        "author",
        "factorio_version",
        "dependencies",
    ]
    for field in required_fields:
        if field not in content:
            print(f"Missing field {field}")
            return False

    previous_version = Version.parse(get_argv(1))
    if previous_version is None:
        print("Previous version was not provided, skipping version check")
        return True
    print(f"previous version was {previous_version}")
    version = Version.parse(content["version"])
    print(f"Current version is {version}")
    if not version > previous_version:
        print("The current version should be greater than the previous version")
        return False
    return True

def validate_changelog():
    if not os.path.isfile("changelog.txt"):
        # TODO Add check to make sure changelog contains the changes from the current version
        print("Missing changelog")
        return False
    return True

def validate_thumbnail():
    if not os.path.isfile("thumbnail.png"):
        print("Missing thumbnail")
        return False
    return True

def validate_mod_structure():
    return validate_info() and validate_changelog() and validate_thumbnail()

if __name__ == "__main__":
    if not validate_mod_structure():
        print("Nope")
        sys.exit(1)
    print("Looks good to me")
    sys.exit(0)
