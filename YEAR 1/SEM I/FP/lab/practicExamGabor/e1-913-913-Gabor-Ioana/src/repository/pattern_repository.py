from domain.pattern import PatternConverter
from exceptions.repository_exceptions import RepositoryException


class PatternRepository:
    def __init__(self, filename):
        self.__filename = filename
        self.__all_patterns = {}
        try:
            self.__load()
        except Exception as e:
            self.__all_patterns = {}

    def __load(self):
        try:
            fi = open(self.__filename, "r")
            lines = fi.readlines()
        except IOError:
            raise RepositoryException("the file is non-existing or corrupt")
        for line in lines:
            pattern = PatternConverter.from_textfile_line_to_pattern(line)
            if pattern in self.__all_patterns:
                raise RepositoryException("multiple patterns with the same name")
            self.__all_patterns[pattern.name] = pattern

    def get_pattern(self, name):
        if self.__all_patterns.get(name) is None:
            raise RepositoryException("This pattern does not exist")
        return self.__all_patterns[name]

    def get_all(self):
        return list(self.__all_patterns)
