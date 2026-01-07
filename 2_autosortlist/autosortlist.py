from bisect import insort
from sys import maxsize
from typing import Iterable, List, SupportsIndex, Union


class AutosortList:
    _list: List

    def __init__(self, iterable: Iterable = None, /):
        if iterable:
            self._list = list(iterable)
            self.sort()
        else:
            self._list = list()

    def copy(self):
        return AutosortList(self._list)

    def append(self, object, /):
        insort(self._list, object)

    def extend(self, iterable: Iterable, /):
        self._list.extend(iterable)
        self._list.sort()

    def index(self, value, start: SupportsIndex = 0, stop: SupportsIndex = maxsize):
        return self._list.index(value, start, stop)

    def count(self, value):
        return self._list.count(value)

    def __len__(self):
        return len(self._list)

    def __iter__(self):
        return iter(self._list)

    def __getitem__(self, key: Union[SupportsIndex, slice], /):
        return self._list[key]

    def __iadd__(self, value):
        insort(self._list, value)
        return self

    def __contains__(self, key: object, /):
        return key in self._list

    def __reversed__(self):
        return reversed(self._list)

    def __eq__(self, other: object):
        if isinstance(other, AutosortList):
            return self._list == other._list
        else:
            return self._list == other
