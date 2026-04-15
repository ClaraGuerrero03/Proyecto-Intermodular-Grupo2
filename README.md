---
# Estructura del proyecto

El repositorio sigue una estructura modular basada en buenas prácticas de automatización con Ansible, separando inventario, playbooks, roles y variables para facilitar el mantenimiento y la escalabilidad del sistema.

```
ansible/
├── ansible.cfg
├── inventario
│   ├── group_vars
│   │   ├── aula1.yml
│   │   ├── aula2.yml
│   │   └── win_aula3.yml
│   └── hosts
├── playbooks
│   ├── apagar_equipos_linux.yml
│   ├── apagar_equipos_windows.yml
│   ├── apagar_todo.yml
│   ├── configurar_aula1.yml
│   ├── configurar_aula2.yml
│   ├── configurar_aula3_win.yml
│   ├── eliminar_usuarios_aula1.yml
│   ├── eliminar_usuarios_aula2.yml
│   ├── eliminar_usuarios_aula3_win.yml
│   ├── mantenimiento_windows.yml
│   ├── mantenimiento.yml
│   ├── reiniciar_equipos_windows.yml
│   └── reiniciar_equipos.yml
├── roles
│   ├── configuracion
│   ├── eliminar_usuarios
│   ├── mantenimiento
│   ├── paquetes
│   ├── seguridad
│   ├── usuarios
│   ├── windows_configuracion
│   ├── windows_eliminar_usuarios
│   ├── windows_mantenimiento
│   ├── windows_paquetes
│   ├── windows_seguridad
│   └── windows_usuarios
├── scripts
│   ├── boostrap_ansible.sh
│   └── configuracion-inicial-win.ps1
└── vars
    ├── eliminar_usuarios_aula1.yml
    ├── eliminar_usuarios_aula2.yml
    ├── paquetes_comunes.yml
    ├── paquetes_windows.yml
    ├── usuarios_aula1.yml
    ├── usuarios_aula2.yml
    ├── usuarios_aula3_win.yml
    └── usuarios_eliminar_aula3_win.yml
```

---

# Organización del proyecto

La estructura está dividida en los siguientes bloques principales:

**inventario/**
Contiene la definición de los equipos gestionados y las variables específicas por grupo mediante `group_vars`.

**playbooks/**
Incluye los playbooks encargados de ejecutar las tareas de automatización sobre los equipos Linux y Windows.

**roles/**
Define los roles reutilizables encargados de:

* instalación de paquetes
* gestión de usuarios
* configuración del sistema
* mantenimiento
* seguridad

incluyendo versiones específicas para sistemas Windows.

**vars/**
Contiene variables específicas utilizadas por los playbooks, separadas por aula o tipo de configuración.

**scripts/**
Incluye scripts de preparación inicial (bootstrap) necesarios para permitir la conexión del servidor Ansible con los equipos cliente.

**ansible.cfg**
Archivo de configuración principal del entorno Ansible.

# Variables de grupo – group_vars 

Este directorio contiene las variables asociadas a cada grupo de equipos definidos en el inventario del proyecto. Su función es centralizar la configuración común de cada aula o conjunto de máquinas para facilitar la automatización mediante Ansible.

El uso de `group_vars` permite aplicar automáticamente variables a todos los hosts de un mismo grupo sin necesidad de repetirlas en los playbooks.

---

# ¿Para qué sirve group_vars?

Permite:

* organizar la configuración por aulas
* reutilizar playbooks sin modificar su contenido
* evitar duplicación de variables
* simplificar mantenimiento del proyecto
* escalar la automatización fácilmente

Las variables definidas aquí se cargan automáticamente cuando se ejecuta un playbook sobre el grupo correspondiente.

---

# Estructura del directorio

Ejemplo actual del proyecto:

```
inventario/group_vars/
├── aula1.yml
├── aula2.yml
└── win_aula3.yml
```

Cada archivo coincide con un grupo definido en:

```
inventario/hosts
```

Ejemplo:

```
[aula1]
[aula2]
[win_aula3]
```

---

# Cómo usar group_vars en el proyecto

## 1. Definir variables dentro del archivo del grupo

Ejemplo en:

```
group_vars/aula1.yml
```

Contenido:

```
usuarios:
  - alumno01
  - alumno02

paquetes:
  - libreoffice
  - vlc
```

Estas variables estarán disponibles automáticamente para todos los hosts del grupo:

```
aula1
```

---

## 2. Utilizar variables dentro de un playbook

Ejemplo:

```
playbooks/configurar_aula1.yml
```

Uso:

```
- name: Instalar paquetes del aula
  apt:
    name: "{{ paquetes }}"
    state: present
```

Ansible cargará automáticamente las variables desde:

```
group_vars/aula1.yml
```

sin necesidad de importarlas manualmente.

---

## 3. Uso en roles

Las variables también pueden usarse directamente dentro de roles.

Ejemplo:

```
roles/paquetes/tasks/main.yml
```

```
- name: Instalar software del aula
  apt:
    name: "{{ paquetes }}"
    state: present
```

Esto permite reutilizar la misma role en distintas aulas con configuraciones diferentes.

---

# Uso con equipos Windows

Ejemplo en:

```
group_vars/win_aula3.yml
```

Variables típicas:

```
usuarios_windows:
  - alumno30
  - alumno40

software_windows:
  - firefox
  - vlc
```

Estas variables son utilizadas por los playbooks Windows ejecutados mediante WinRM.

Ejemplo:

```
playbooks/configurar_aula3_win.yml
```

---

# Ejemplo de ejecución real

Aplicar configuración del aula 1:

```
ansible-playbook -i inventario/hosts playbooks/configurar_aula1.yml
```

Aplicar configuración del aula Windows:

```
ansible-playbook -i inventario/hosts playbooks/configurar_aula3_win.yml
```

Ansible cargará automáticamente las variables definidas en:

```
group_vars/
```

según el grupo destino.

---
