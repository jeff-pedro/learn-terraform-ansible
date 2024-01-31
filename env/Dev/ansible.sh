cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible
tee -a playbook.yml > /dev/null <<EOT
- hosts: localhost
  vars:
    app_path: /home/ubuntu/api

  tasks:
    - name: Install python and virtualenv
      apt:
        pkg:
          - python3
          - virtualenv
        update_cache: yes
      become: true

    - name: Git clone
      ansible.builtin.git:
        repo: https://github.com/alura-cursos/clientes-leo-api.git
        dest: { app_path }
        version: master
        force: true

    - name: Install dependencies with pip (Django and Django Rest)
      pip:
        virtualenv: "{{app_path}}/venv"
        requirements: "{{app_path}}/requirements.txt"

    - name: Include hosts in settings
      lineinfile:
        path: "{{app_path}}/setup/settings.py"
        regexp: "ALLOWED_HOSTS"
        line: 'ALLOWED_HOSTS = ["*"]'
        backrefs: yes

    - name: Setup database
      shell: ". {{app_path}}/venv/bin/activate; python {{app_path}}/manage.py migrate"

    - name: Load initinal data
      shell: ". {{app_path}}/venv/bin/activate; python {{app_path}}/manage.py loaddata clientes.json"

    - name: Start server
      shell: ". {{app_path}}/venv/bin/activate; nohup python {{app_path}}/manage.py runserver 0.0.0.0:8000 &"
EOT
ansible-playbook playbook.yml