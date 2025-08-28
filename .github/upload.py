import json
import sys
import requests
from os import getenv

def get_mod_name():
    with open("info.json") as info_file:
        return json.load(info_file)["name"]

MOD_PORTAL_URL = "https://mods.factorio.com"
INIT_UPLOAD_URL = f"{MOD_PORTAL_URL}/api/v2/mods/releases/init_upload"

modname = get_mod_name()
filepath = sys.argv[1]

if ("--dry-run" in sys.argv):
    print(f"Will upload {filepath} using the name {modname}")
    sys.exit(0)

apikey = getenv("MOD_UPLOAD_API_KEY")
if (apikey is None):
    print("Missing api key")
    sys.exit(2)

request_body = {"mod": modname}
request_headers = {"Authorization": f"Bearer {apikey}"}
response = requests.post(INIT_UPLOAD_URL, data=request_body, headers=request_headers)

if not response.ok:
    print(f"init_upload failed: {response.text}")
    sys.exit(1)

upload_url = response.json()["upload_url"]

with open(filepath, "rb") as file:
    request_body = {"file": file}
    response = requests.post(upload_url, files=request_body)

if not response.ok:
    print(f"upload failed: {response.text}")
    sys.exit(1)

print(f"upload successful: {response.text}")
