from enum import Enum
from typing import Union

from autosortlist import AutosortList


class ElementType(Enum):
    STR = str
    INT = int
    FLOAT = float


class AutosortListLibrary(object):
    asl: AutosortList
    element_type: Union[str, int, float]

    def __init__(self, element_type: ElementType = ElementType.STR):
        self.asl = AutosortList()
        self.element_type = element_type.value

    def copy(self):
        return self.asl.copy()

    def append(self, obj):
        self.asl.append(self.element_type(obj))

    def extend(self, *args):
        self.asl.extend([self.element_type(value) for value in args])

    def index(self, value):
        return self.asl.index(self.element_type(value))

    def count(self, value):
        return self.asl.count(self.element_type(value))

    def __len__(self):
        return len(self.asl)

    def get_length(self):
        return len(self)

    def __getitem__(self, key):
        return self.asl[key]

    def get(self, index):
        return self.asl[self.element_type(index)]

    def __contains__(self, value):
        return value in self.asl

    def contains(self, value):
        return self.element_type(value) in self

    def list_should_equal(self, *args):
        for index, value in enumerate(args):
            value = self.element_type(value)
            try:
                if value != self[index]:
                    raise AssertionError(
                        f"expected {value} at index {index}, got {self[index]}"
                    )
            except IndexError:
                raise AssertionError(
                    f"expected {value} at index {index}, but it is out of range"
                )
