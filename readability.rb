class Readability
    attr_accessor :sentence_count, :word_count, :syllable_count, :flesch_index

    def initialize(document)
        @document = document
        @sentence_count = 1
        @word_count = 0
        @syllable_count = 0
        @flesch_index = 0
        @words = []
    end
    
    def countSentences
        sentences = []
        initial_sentences = @document.gsub(/"|'/,'').gsub(/\n/,' ').strip.split(/\.|\?|\!/)
        initial_sentences.each {|sentence| 
            if !sentence.empty?
                sentences << sentence
            end
        }
        @sentence_count =  sentences.length
        @sentence_count = (@sentence_count < 1 ? 1: @sentence_count)
    end
    def separateWords
        initial_words = @document.gsub(/"|'/,'').split(/\n|\ |\.|\?|\!|\:|\;|\,/)
        @words = initial_words.select{|word| word if !word.empty?}
        @word_count = @words.length
    end
    def countSyllables
        @syllable_count = 0
        @words.each{ |word|
            word_syllable_count = word.downcase.\
                gsub(/ise|ize|ive|ice|ure|ance|ince|are/,'i').\
                gsub(/e[aeiouy]/,'e').\
                gsub(/[aiouy][aeiouy][aeiouy]|[aiouy][aeiouy]/,'y').\
                gsub(/e\b/,'').\
                scan(/[aeiouy]/).length
            word_syllable_count = (word_syllable_count < 1 ? \
                1: word_syllable_count)
            @syllable_count += word_syllable_count 
        }

    end
    def calculateFleschIndex
        countSentences
        separateWords
        countSyllables
        @flesch_index =  (206.835 - (84.6 * @syllable_count / @word_count) \
            - (1.015 * @word_count / @sentence_count)).round(2)
    end
end