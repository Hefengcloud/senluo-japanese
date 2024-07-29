import os
import yaml
import cutlet

ej_path = '/Users/feelang/source/everjapan/everjapan.github.io'
src_file_path = os.path.join(os.getcwd(), 'assets/data/proverbs.yaml')
dest_folder_path = os.path.join(ej_path, '_proverbs')

with open(src_file_path, 'r') as f:
    items = yaml.safe_load(f)

katsu = cutlet.Cutlet()

print(len(items))

for index, item in enumerate(items):
    name = item['item']
    yomi = item['yomi']
    key = '-'.join(katsu.romaji(yomi).split('/')[0].lower().split(' '))
    print(yomi, key)

    file_path = os.path.join(dest_folder_path, f"{(index + 1):03}-{key}.md")

    with open(file_path, 'w') as f:
        f.write('---\n')
        f.write(f'title: {name}\n')
        f.write(f'layout: single\n')
        f.write(f'permalink: /proverbs/{key}\n')
        f.write(f'excerpt: {yomi}\n')
        f.write(f'---\n\n')
        f.write(yomi)
        f.write('\n\n')
        f.write('## 解释\n\n')
        for meaning in item['zh']:
            f.write(f'{meaning}\n\n')
        f.write('## 例句\n\n')
        if 'examples' in item:
            for example in item['examples']:
                zh = example['zh']
                jp = example['jp']
                f.write(f"> {jp}\n")
                f.write(f">\n")
                f.write(f"> → {zh}\n\n")