` Module "mira" indexes personal CRM entries from `

std := load('../vendor/std')
str := load('../vendor/str')
json := load('../vendor/json')

log := std.log
slice := std.slice
cat := std.cat
map := std.map
each := std.each
filter := std.filter
append := std.append
readFile := std.readFile
split := str.split
trim := str.trim
replace := str.replace
hasPrefix? := str.hasPrefix?
trimPrefix := str.trimPrefix
deJSON := json.de

tokenizer := load('../lib/tokenizer')
tokenize := tokenizer.tokenize
tokenFrequencyMap := tokenizer.tokenFrequencyMap

Newline := char(10)

MiraFilePath := env().HOME + '/noctd/data/mira/mira.txt'

normalizePerson := person => {
	name: person.name
	work: person.work :: {
		() -> ''
		_ -> person.work
	}
	place: person.place :: {
		() -> ''
		_ -> person.place
	}
	notes: person.notes :: {
		() -> ''
		_ -> person.notes
	}
	mtg: person.mtg :: {
		() -> []
		_ -> person.mtg
	}
}

getDocs := withDocs => readFile(MiraFilePath, file => file :: {
	() -> (
		log('[mira] could not read mira data file!')
		[]
	)
	_ -> (
		people := deJSON(file)
		docs := map(people, (person, i) => (
			person := normalizePerson(person)
			lines := [
				'work: ' + person.work
				'place: ' + person.place
				person.notes
			]
			append(lines, person.mtg)
			personEntry := cat(lines, Newline)

			{
				id: 'mira' + string(i)
				tokens: tokenize(person.name + ' ' + personEntry)
				content: personEntry
				title: person.name
			}
		))
		withDocs(docs)
	)
})

