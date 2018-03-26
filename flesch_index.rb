require_relative 'readability.rb'
require 'tk'
require 'tkextlib/tile'

my_document = ""
scroll_bar = TkVariable.new;
document = TkVariable.new; 
sentences = TkVariable.new;
words = TkVariable.new;
syllables = TkVariable.new;
flesch_index = TkVariable.new; 

def readFile(file_name) 
    IO.read file_name
end
load_file = proc {
    my_document = readFile("docs/sample.txt")
    document.delete 1.0, 'end'
    document.insert 1.0, my_document
}
analyse = proc {
    readability = Readability.new(document.get 1.0, 'end')
    readability.calculateFleschIndex
    sentences.value =  "Sentences: " + readability.sentence_count.to_s
    words.value = "Words: " + readability.word_count.to_s
    syllables.value = "Syllables: " + readability.syllable_count.to_s
    flesch_index.value = "Flesch Index\n(higher simpler):\n" + readability.flesch_index.to_s
}

root = TkRoot.new {title "Readability Analysis"}
content = Tk::Tile::Frame.new(root) {padding "3 3 12 12"}.grid( :sticky => 'nsew')

TkGrid.columnconfigure root, 0, :weight => 1; TkGrid.rowconfigure root, 0, :weight => 1

document = Tk::Text.new(content) {width 60; height 50; wrap 'word'}.grid( :column => 0, :row => 0, :rowspan => 6, :sticky => 'nsew')
#scroll_bar = Tk::Tile::Scrollbar.new(content) {orient "vertical"; command proc{|*args| document.yview(*args);} }
#document['yscrollcommand'] = proc{|first,last| scroll_bar.set(first,last);}
Tk::Tile::Button.new(content) {text 'Load'; command load_file}.grid( :column => 1, :row => 0, :sticky => 'e')
Tk::Tile::Button.new(content) {text 'Analyse'; command analyse}.grid( :column => 1, :row => 1, :sticky => 'e')
Tk::Tile::Label.new(content) {textvariable sentences}.grid( :column => 1, :row => 2, :sticky => 'we')
Tk::Tile::Label.new(content) {textvariable words}.grid( :column => 1, :row => 3, :sticky => 'we')
Tk::Tile::Label.new(content) {textvariable syllables}.grid( :column => 1, :row => 4, :sticky => 'we')
Tk::Tile::Label.new(content) {textvariable flesch_index}.grid( :column => 1, :row => 5, :sticky => 'we')


#TkWinfo.children(content).each {|w| TkGrid.configure w, :padx => 5, :pady => 5}
#f.focus


Tk.mainloop