import os, json, random, shutil, time, sys


def generate_defines(json_data, name):

    path = "../" + name.replace(".json", '.fx')

    dat = name.split("_")
    try:
        Charname = dat[1]
    except:
        return
    with open(path, 'w') as f:
        f.writelines(f"#define UVDir float2(0.0f, 0.0f)\n\n")
        floats = json_data.get("m_SavedProperties", {}).get("m_Floats", {})
        colors = json_data.get("m_SavedProperties", {}).get("m_Colors", {})
        texenvs = json_data.get("m_SavedProperties", {}).get("m_TexEnvs", {})
        shader = json_data.get("m_Shader", "")["m_PathID"]
        print(shader)
        if shader == -5456259551927882286 or "cheek" in name.lower():
            f.writelines("#define DisableOutline\n")
            
        if shader == 4382356676065627482 or shader == 7557468678838382648:
            f.writelines("#define NoLight 1\n")
        else:
            f.writelines("#define NoLight 0\n")



        for key, value in floats.items():
            f.writelines(f"#define {key} {value}f\n")

        for key, val in colors.items():
            r, g, b, a = val["r"], val["g"], val["b"], val["a"]
            f.writelines(f"#define {key} float4({r}f, {g}f, {b}f, {a}f)\n")



        if "eye" in name.lower():
            f.writelines(f"#include <shaders/eye_shader.fxsub>")
        else:
            f.writelines(f"#include <shaders/base_shader.fxsub>")

    print(f"Processed {name}")


for file in os.listdir("Materials"):
    if file.endswith(".json"):
        if not "HairShadow" in file:
            with open(os.path.join("Materials", file)) as f:
                data = json.load(f)
                generate_defines(data, file)
        os.remove(os.path.join("Materials", file))

os.removedirs("Materials") # Delete Folder.

for file in os.listdir(): # done after processing. don't need these duh
    if not file.endswith(".py") and not file.endswith(".spec") and not file.endswith(".exe"):
        os.remove(file)


# while True:
    # print("BEING MEGUCA IS SUFFERING")