from tkinter import Tk, Text, font, END, DISABLED, WORD, NORMAL, W, E, N, S
from tkinter.ttk import Frame, Entry, Label, Checkbutton, Button, Combobox
from typeguard import typechecked, Union


class StopExecution(Exception):
    pass


@typechecked
def stop_execution(text: str) -> None:
    raise StopExecution("Ошибка!\n{0}".format(text))


@typechecked
def fix_separator(numeric_text: str) -> str:
    return numeric_text.replace(",", ".")


@typechecked
def get_number_from(entry: Entry) -> float:
    try:
        return float(fix_separator(entry.get()))
    except ValueError:
        entry.focus_set()
        entry.select_range(0, END)
        stop_execution("Неверный формат строки")


@typechecked
def assert_that(condition: bool, warning: str) -> None:
    if not condition:
        stop_execution(warning)


@typechecked
def assert_positive(value: Union[int, float], name: str) -> None:
    assert_that(value > 0,
                "{0} - значение отрицательно или равно нулю".format(name))


@typechecked
def set_entry(entry: Entry, value: str) -> None:
    state = entry.state()
    entry.config(state="normal")
    entry.delete(0, END)
    entry.insert(0, value)
    entry.config(state=state)


@typechecked
def clear_entry(entry: Entry) -> None:
    set_entry(entry, "")


class BaseApp(Tk):
    @typechecked
    def __init__(self, title: str) -> None:
        super().__init__()
        self.iconbitmap(r'favicon.ico')
        self.title(title)
        self.resizable(width=False, height=False)
        self._common_widgets()
        self._create_widgets()

    @typechecked
    def _common_widgets(self) -> None:
        self._frame = Frame(self)
        self._frame.grid(row=0, column=0, padx=10, pady=8)
        self._border = Frame(self._frame)
        self._status = Text(
            self._frame, height=1, width=40, state=DISABLED,
            font=font.nametofont("TkDefaultFont"), wrap=WORD)

    @typechecked
    def _event_on_run(self) -> None:
        try:
            self._output_results(self._read_values())
        except StopExecution as exp:
            self._show_warning(exp.__str__())

    @typechecked
    def _check_that(self, condition: bool, warning: str) -> None:
        if not condition:
            self._show_warning(warning)

    @typechecked
    def _clear_status(self) -> None:
        self._status.config(state=NORMAL)
        self._status.delete(1.0, END)
        self._status.config(state=DISABLED)
        self._border.grid_forget()
        self._status.grid_forget()

    @typechecked
    def _set_status(self, value: str, column: int) -> None:
        self._status.config(state=NORMAL)
        self._status.insert(END, "{0}.\n".format(value))
        self._status.config(state=DISABLED)
        self._border.grid(row=0, column=column, padx=4)
        self._status.grid(row=0, column=column + 1,
                          rowspan=self._frame.grid_size()[1],
                          sticky=N+S, pady=3, ipady=1, padx=2)

    @typechecked
    def _label(self, init: dict, grid: dict) -> Label:
        label = Label(
            master=init["master"] if "master" in init else self._frame,
            text=init["text"])
        label.grid(row=grid["row"], column=grid["column"], sticky=W, padx=2)
        return label

    @typechecked
    def _entry(self, init: dict, grid: dict) -> Entry:
        entry = Entry(
            master=init["master"] if "master" in init else self._frame,
            state=init["state"] if "state" in init else "normal",
            width=1)
        entry.grid(
            row=grid["row"], column=grid["column"],
            columnspan=grid["columnspan"] if "columnspan" in grid else 1,
            sticky=W+E, padx=2, pady=3, ipady=1)
        return entry

    @typechecked
    def _chkbox(self, init: dict, grid: dict) -> Checkbutton:
        chkbox = Checkbutton(
            master=init["master"] if "master" in init else self._frame,
            text=init["text"], variable=init["variable"],
            command=init["command"] if "command" in init else None)
        chkbox.grid(row=grid["row"], column=grid["column"], sticky=W, padx=2)
        return chkbox

    @typechecked
    def _combo(self, init: dict, grid: dict, index: int=0) -> Combobox:
        combo = Combobox(
            master=init["master"] if "master" in init else self._frame,
            textvariable=init["var"], state="readonly", values=init["values"],
            width=init["width"] if "width" in init else 1)
        combo.grid(row=grid["row"], column=grid["column"],
                   columnspan=grid["columnspan"] if "columnspan" in grid
                   else 1, sticky=W+E, padx=2, pady=3, ipady=1)
        combo.current(index)
        return combo

    @typechecked
    def _button(self, init: dict, grid: dict) -> Button:
        button = Button(
            master=init["master"] if "master" in init else self._frame,
            text=init["text"], command=init["command"])
        button.grid(row=grid["row"], column=grid["column"], padx=2, pady=4)
        return button

    @typechecked
    def _button_run(self, init: dict, grid: dict) -> Button:
        init["text"] = "Выполнить"
        init["command"] = self._event_on_run
        return self._button(init, grid)

    @typechecked
    def _create_widgets(self) -> None:
        pass

    @typechecked
    def _read_values(self) -> None:
        pass

    @typechecked
    def _output_results(self, _) -> None:
        pass

    @typechecked
    def _show_warning(self, text: str) -> None:
        pass
