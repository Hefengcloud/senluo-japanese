import os
import yaml
import cutlet

ej_path = '/Users/feelang/source/everjapan/everjapan.github.io'
src_file_path = os.path.join(os.getcwd(), 'assets/data/proverbs.yaml')
dest_folder_path = os.path.join(ej_path, '_proverbs')

katsu = cutlet.Cutlet()

def build_proverb_navigation(proverbs, nav_file_path: str):
  with open(nav_file_path, 'r') as f:
    data = yaml.safe_load(f)
    proverb_nav = {
        "title": "ことわざ",
        "children": [],
    }
    for proverb in proverbs:
      name = proverb['item'].strip()
      yomi = proverb['yomi'].strip()
      key = '-'.join(katsu.romaji(yomi).split('/')[0].lower().split(' '))
      proverb_nav["children"].append({
         'title': name, 
         'url': f'/proverbs/{key}',
         }
      )
    data['proverbs'] = proverb_nav

    print(proverb_nav)
  
#   with open(nav_file_path, 'w', encoding='utf-8') as f:
    # yaml.dump(data, f, allow_unicode=True)

def build_everjapan_proverbs():
    workspace_path = '/Users/feelang/source/everjapan/everjapan.github.io'

    # Load proverbs from CMS
    with open(src_file_path, 'r') as f:
        items = yaml.safe_load(f)

    # Build the everjapan navigation
    nav_file_path = os.path.join(workspace_path, '_data', 'navigation.yml')
    build_proverb_navigation(items, nav_file_path)

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

            f.write('## 意思\n\n')
            for meaning in item['zh']:
                f.write(f'{meaning}\n\n')

            f.write('## 解释\n\n')
            if 'explanations' in item:
                for explanation in item['explanations']:
                    f.write(f'{explanation}\n\n')

            f.write('## 例句\n\n')
            if 'examples' in item:
                for example in item['examples']:
                    zh = example['zh']
                    jp = example['jp']
                    f.write(f"> ◎ {jp}\n")
                    f.write(f">\n")
                    f.write(f"> → {zh}\n\n")