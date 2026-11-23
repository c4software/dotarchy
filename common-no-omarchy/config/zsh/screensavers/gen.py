import os, sys
F = {
'A':[".###.","#...#","#####","#...#","#...#"],
'B':["####.","#...#","####.","#...#","####."],
'C':[".####","#....","#....","#....",".####"],
'Ç':[".####","#....","#....","#....",".####","..#.."],
'D':["####.","#...#","#...#","#...#","####."],
'E':["#####","#....","####.","#....","#####"],
'É':["..#..","#####","#....","###..","#####"],
'F':["#####","#....","####.","#....","#...."],
'G':[".####","#....","#..##","#...#",".####"],
'H':["#...#","#...#","#####","#...#","#...#"],
'I':["###",".#.",".#.",".#.","###"],
'J':["..###","...#.","...#.","#..#.",".##.."],
'K':["#...#","#..#.","###..","#..#.","#...#"],
'L':["#....","#....","#....","#....","#####"],
'M':["#...#","##.##","#.#.#","#...#","#...#"],
'N':["#...#","##..#","#.#.#","#..##","#...#"],
'O':[".###.","#...#","#...#","#...#",".###."],
'P':["####.","#...#","####.","#....","#...."],
'Q':[".###.","#...#","#.#.#","#..#.",".##.#"],
'R':["####.","#...#","####.","#..#.","#...#"],
'S':[".####","#....",".###.","....#","####."],
'T':["#####","..#..","..#..","..#..","..#.."],
'U':["#...#","#...#","#...#","#...#",".###."],
'V':["#...#","#...#","#...#",".#.#.","..#.."],
'W':["#...#","#...#","#.#.#","##.##","#...#"],
'X':["#...#",".#.#.","..#..",".#.#.","#...#"],
'Y':["#...#",".#.#.","..#..","..#..","..#.."],
'Z':["#####","...#.","..#..",".#...","#####"],
'0':[".###.","#..##","#.#.#","##..#",".###."],
'1':[".#.","##.",".#.",".#.","###"],
'4':["#..#.","#..#.","#####","...#.","...#."],
'8':[".###.","#...#",".###.","#...#",".###."],
'!':["#","#","#",".","#"],
'?':["####.","....#","..##.",".....","..#.."],
'-':[".....",".....","#####",".....","....."],
"'":["#","#",".",".","."],
' ':["..","..","..","..",".."],
}
def big(text):
    rows = 6
    grid = [[] for _ in range(rows)]
    for ch in text:
        g = F[ch]
        w = len(g[0])
        for r in range(rows):
            line = g[r] if r < len(g) else "."*w
            grid[r] += list(line) + ["."]
    H, W = rows+1, 2*len(grid[0])+2
    cells = [[" "]*W for _ in range(H)]
    for r in range(rows):
        for c, v in enumerate(grid[r]):
            if v == "#":
                cells[r][2*c] = cells[r][2*c+1] = "█"
    for r in range(rows):
        for c, v in enumerate(grid[r]):
            if v == "#":
                for cc in (2*c+1, 2*c+2):
                    if cells[r+1][cc] == " ":
                        cells[r+1][cc] = "░"
    out = ["".join(row).rstrip() for row in cells]
    while out and not out[-1].strip(): out.pop()
    return out

def center(lines, width):
    w = max(len(l) for l in lines)
    pad = " "*((width-w)//2)
    return [(pad + l).rstrip() for l in lines]

def scene(*parts):
    blocks = []
    for p in parts:
        if isinstance(p, tuple):
            for word in p:
                blocks.append(big(word)); blocks.append([""])
        elif isinstance(p, list):
            blocks.append(p)  # ascii art: centred as one block
        else:
            for l in (p.split("\n") if p else [""]):
                blocks.append([l])
    width = max(len(l) for b in blocks for l in b)
    lines = [l for b in blocks for l in center(b, width)]
    while lines and not lines[-1]: lines.pop()
    return "\n".join(lines) + "\n"

S = {}
S["dns"] = scene(
 ("C'EST PAS", "LE DNS"),
 "",
 "Ce n'est pas le DNS.",
 "Ça ne peut pas être le DNS.",
 "...",
 "C'était le DNS.",
 "",
 "— haïku de l'administrateur AdGuard, 3h du matin",
)
S["machine"] = scene(
 ("ÇA MARCHE", "CHEZ MOI"),
 "",
 "« Mais monsieur, j'ai rien touché ! »",
 "— chaque élève de BTS SIO, depuis la création du BTS",
)
S["rtfm"] = scene(
 ("RTFM",),
 "",
 "Le cours est sur le VitePress.",
 "Oui, le lien a encore changé.",
 "Non, je ne le remets pas dans le chat.",
)
S["teapot"] = scene(
 [
 "       (  )   (   )  )",
 "        ) (   )  (  (",
 "        ( )  (    ) )",
 "    _____________________",
 "   <_____________________> ___",
 "   |                     |/ _ \\",
 "   |      CAFE.EXE       |  | |",
 "   |      PID 1          |_/ /",
 "___|                     |__/",
 "/    \\___________________/    \\",
 "\\_____________________________/",
 ],
 "",
 ("418",),
 "$ sudo make me-a-coffee",
 "HTTP 418 — I'm a teapot.  Reviens après le TP noté.",
)
S["segv"] = scene(
 ("SEGFAULT",),
 "",
 "Hyprland a vu le capot se fermer.",
 "Hyprland a paniqué.",
 "Hyprland s'est souvenu du --safe-mode... qui ne fait rien.",
 "",
 "core dumped · omarchy#16749 · PR en attente",
)
S["fans"] = scene(
 ("VRRRRR",),
 [
 "  \\  |  /      \\  |  /      \\  |  /",
 " -- (@) --    -- (@) --    -- (@) --",
 "  /  |  \\      /  |  \\      /  |  \\",
 ],
 "",
 "Ventilos en mode auto.  (auto = « comme ils veulent »)",
 "",
 "Le serveur est au repos. Le serveur fait 60 dB.",
 "Le serveur est au repos.",
)
S["agents"] = scene(
 ("4 AGENTS", "1 HUMAIN"),
 "",
 ["claude : « je refactore »      codex : « je commite »",
  "pi     : « je relis »          omp   : « je réfléchis »"],
 "",
 "toi : « ...quelqu'un a lancé les tests ? »",
)
S["friday"] = scene(
 ("ON NE", "DEPLOIE", "PAS LE", "VENDREDI"),
 "",
 "(sauf Headscale. depuis le serveur. à distance.)",
 "(ah non, pas ça non plus.)",
)
d = os.path.dirname(os.path.abspath(__file__))
os.makedirs(d, exist_ok=True)
for k, v in S.items():
    open(f"{d}/{k}.txt", "w").write(v)
    print(k, max(len(l) for l in v.splitlines()), len(v.splitlines()))
