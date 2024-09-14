const data = [
    {
        "first-name": "Dragos",
        "last-name": "Talaba",
        "age": 32,
    },
    {
        "first-name": "Cosmin",
        "last-name": "Timis",
        "age": 25,
    },
    {
        "first-name": "Sebastian",
        "last-name": "Hojda",
        "age": 24,
    },
    {
        "first-name": "Gabriel",
        "last-name": "Horj",
        "age": 30,
    },
    {
        "first-name": "Alex",
        "last-name": "Pop",
        "age": 40,
    },
    {
        "first-name": "Ionut",
        "last-name": "Popescu",
        "age": 45,
    },
    {
        "first-name": "Grigore",
        "last-name": "Ionescu",
        "age": 50,
    },
    {
        "first-name": "Mihai",
        "last-name": "Dumitrescu",
        "age": 55,
    },
];

const tableContent = document.getElementById("table-content");

const createRow = (data) => {
    const row = document.createElement('tr');
    Object.keys(data).forEach(key => {
        const cell = document.createElement('td');
        cell.textContent = data[key];
        row.appendChild(cell);
    });
    return row;
};

const getTableContent = (data) => {
    data.map(item => {
        tableContent.appendChild(createRow(item));
    });
};


const sortData = (data, column, direction = 'asc') => {
    tableContent.innerHTML = '';
    const sortedData = direction == 'asc' ?
        [...data].sort((a, b) => a[column] > b[column] ? 1 : -1) :
        [...data].sort((a, b) => a[column] < b[column] ? 1 : -1)
    getTableContent(sortedData);
};


const tableButtons = document.querySelectorAll('th button');

const resetButtons = (e) => {
    [...tableButtons].forEach(button => {
        if (button !== e.target) {
            button.removeAttribute('data-direction');
        }
    });
};

window.addEventListener('load', () => {
    getTableContent(data);


    [...tableButtons].forEach(button => {
        button.addEventListener('click', (e) => {

            resetButtons(e)
            if (e.target.getAttribute('data-direction') == 'desc') {
                sortData(data, e.target.id, 'desc');
                e.target.setAttribute('data-direction', 'asc');
            } else {
                sortData(data, e.target.id, 'asc');
                e.target.setAttribute('data-direction', 'desc');
            }
        });
    });
});