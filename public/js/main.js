// Menú hamburguesa
document.addEventListener('DOMContentLoaded', function () {
    const menuToggle = document.createElement('button');
    menuToggle.classList.add('menu-toggle');
    menuToggle.setAttribute('aria-label', 'Menú');
    menuToggle.innerHTML = '<span></span><span></span><span></span>';

    const nav = document.querySelector('nav');
    const navUl = nav.querySelector('ul');

    // Insertar botón antes del ul
    nav.insertBefore(menuToggle, navUl);

    menuToggle.addEventListener('click', function () {
        navUl.classList.toggle('show');
    });

    // Cerrar menú al hacer clic en un enlace
    navUl.querySelectorAll('a').forEach(link => {
        link.addEventListener('click', () => {
            navUl.classList.remove('show');
        });
    });
});