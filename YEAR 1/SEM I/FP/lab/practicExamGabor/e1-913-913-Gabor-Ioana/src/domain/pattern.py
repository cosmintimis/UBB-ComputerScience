class Pattern:
    def __init__(self, name, size, coordinates):
        self.__name = name
        self.__size = size
        self.__coordinates = coordinates

    @property
    def name(self):
        return self.__name

    @property
    def size(self):
        return self.__size

    @property
    def coordinates(self):
        return self.__coordinates


class PatternConverter:
    @staticmethod
    def from_textfile_line_to_pattern(line: str):
        tokens = line.split(",")
        name = tokens[0].strip()
        size = int(tokens[1].strip())
        coordinates = []
        for i in range(2, len(tokens), 2):
            x = int(tokens[i].strip())
            y = int(tokens[i + 1].strip())
            coordinates.append((x, y))
        return Pattern(name, size, coordinates)
