import os
import re

# Set this to the root directory of your Obsidian vault
OBSIDIAN_VAULT_PATH = "/Users/brian.samek/Documents/Notes"

# Set this to the output file path
OUTPUT_FILE_PATH = "/Users/brian.samek/Desktop/obsidian.md"

def is_markdown_file(filename):
    return filename.lower().endswith('.md')

def combine_markdown_files(root_dir, output_file):
    with open(output_file, 'w', encoding='utf-8') as outfile:
        for root, dirs, files in os.walk(root_dir):
            for file in files:
                if is_markdown_file(file):
                    file_path = os.path.join(root, file)
                    relative_path = os.path.relpath(file_path, root_dir)

                    with open(file_path, 'r', encoding='utf-8') as infile:
                        content = infile.read()
                        outfile.write(content)

if __name__ == "__main__":
    combine_markdown_files(OBSIDIAN_VAULT_PATH, OUTPUT_FILE_PATH)
    print(f"Combined markdown files have been saved to {OUTPUT_FILE_PATH}")
