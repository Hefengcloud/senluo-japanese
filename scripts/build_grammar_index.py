import os
import yaml


grammar_index_file_path = os.path.join(os.getcwd(), 'assets/grammar/index.yaml')

# Load grammars from the index yaml file
def load_grammars(index_file_path: str):
  with open(index_file_path, 'r') as f:
    return yaml.safe_load(f)

def load_grammar_details(grammar_file_path: str):
  with open(grammar_file_path, 'r') as f:
    item = yaml.safe_load(f)
    return item

def build_grammar_index(grammars, dest_file_path: str):
    with open(dest_file_path, 'w') as f:
      f.write("""---
title: JLPT语法精讲
permalink: /jlpt/grammars/
---

""")
      for grammar in grammars:
        level = grammar['level']
        items = grammar['items']
        f.write(f'## {level} ({len(items)})\n')
        for item in items:
          key = item['key']
          name = item['name']
          url = f"/jlpt/grammars/{level.lower()}/{key}"
          markdown_link = f"- [{name}]({url})\n\n"
          f.write(markdown_link)

def build_grammar_navigation(grammars, nav_file_path: str):
  with open(nav_file_path, 'r') as f:
    data = yaml.safe_load(f)
    grammar_nav = []
    for grammar in grammars:
      level = grammar['level']
      items = grammar['items']
      grammar_nav.append({
        'title': grammar['level'],
        'children': [{'title': item['name'].split('/')[0].strip(), 'url': f'/jlpt/grammars/{level.lower()}/{item['key']}'} for item in items]
      })
    data['jlpt-grammars'] = grammar_nav
  
  with open(nav_file_path, 'w', encoding='utf-8') as f:
    yaml.dump(data, f, allow_unicode=True)

def build_grammar_files(grammars, dest_folder_path: str):
  for grammar in grammars:
     level = grammar['level']
     for item in grammar['items']:
        key = item['key']
        name = item['name']
        src_file_path = os.path.join(os.getcwd(), f'assets/grammar/{level.lower()}/{key}.yaml')
        print("==>", src_file_path)
        grammar_details = load_grammar_details(src_file_path)
        file_path = os.path.join(dest_folder_path, f'{level.lower()}-{key}.md')
        with open(file_path, 'w') as f:
          f.write(f"""---
title: {name}
layout: grammar
permalink: /jlpt/grammars/{level.lower()}/{key}
level: {level}
---
""")
          # write meaning
          f.write('\n## 意思\n\n')
          meanings = grammar_details['meanings']
          f.write('### 🇨🇳 中文\n\n')
          if 'zh' in meanings:
            for meaning in meanings['zh']:
              f.write(f'- {meaning}\n')
          f.write('\n### 🇯🇵 日文\n\n')
          if 'jp' in meanings:
            for meaning in meanings['jp']:
              f.write(f'- {meaning}\n')
          f.write('\n### 🇬🇧 英文\n\n')
          if 'en' in meanings:
            for meaning in meanings['en']:
              f.write(f'- {meaning}\n')
          f.write('\n## 接续\n\n')
          for conjugation in grammar_details['conjugations']:
            f.write(f'- {conjugation}\n')
          
          f.write('\n## 备注\n\n')
          if 'explanations' in grammar_details:
            for explanation in grammar_details['explanations']:
              f.write(f'- {explanation}\n')

          f.write('\n## 例句\n\n')
          for example in grammar_details['examples']:
            f.write(f'> {example['jp']}\n')
            f.write(f'>\n')
            f.write(f'> → {example['zh']}')
            f.write('\n\n')

def build_everjapan():
  workspace_path = '/Users/feelang/source/everjapan/everjapan.github.io'
  ej_grammar_index_file_path = os.path.join(workspace_path, '_jlpt', '00-grammar.md')
  ej_grammar_folder_path = os.path.join(workspace_path, '_jlpt-grammars')
  ej_nav_file_path = os.path.join(workspace_path, '_data', 'navigation.yml')
  grammars = load_grammars(grammar_index_file_path)
  build_grammar_index(grammars, ej_grammar_index_file_path)
  build_grammar_navigation(grammars, ej_nav_file_path)
  build_grammar_files(grammars, ej_grammar_folder_path)

if __name__ == '__main__':
  build_everjapan()