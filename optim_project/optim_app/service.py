import os
import random as rn
import patoolib
import shutil

from hashlib import md5

from django.core.files.storage import FileSystemStorage

from optim_project.settings import BASE_DIR


class ServiceToCreateDir:
    def __init__(self, data):
        self.data = data
        self.path, self.path2 = self.get_path_with_hash(data["name"])

    def save_directory(self):
        FULL_PATH_TO_FILE = os.path.join(BASE_DIR, 'optim_app\\userfunctions', self.path)

        fss = FileSystemStorage(location=FULL_PATH_TO_FILE)
        fss.save(self.data["hash"].name, self.data["hash"])

        os.mkdir(os.path.join(FULL_PATH_TO_FILE, self.path2))
        patoolib.extract_archive(os.path.join(FULL_PATH_TO_FILE, self.data["hash"].name),
                                 outdir=os.path.join(FULL_PATH_TO_FILE, self.path2))

        os.remove(os.path.join(FULL_PATH_TO_FILE, self.data["hash"].name))

        return os.path.join(self.path, self.path2)


    def get_path_with_hash(self, some_str):
        rn.seed()
        salt = str(rn.randint(1000, 999999))

        str_to_hash = some_str + salt
        hash_str = md5(str_to_hash.encode()).hexdigest()
        path = hash_str[:2] + '\\' + hash_str[2:4]
        new_file_name = hash_str[4:]

        return path, new_file_name

class ServiceToDeleteDir:
    def __init__(self, path):
        self.path = path

    def del_directory(self):
        FULL_PATH = os.path.join(BASE_DIR, 'optim_app\\userfunctions', self.path)
        FULL_PATH_1 = os.path.join(BASE_DIR, 'optim_app\\userfunctions', self.path[:2])
        FULL_PATH_2 = os.path.join(BASE_DIR, 'optim_app\\userfunctions', self.path[:5])

        shutil.rmtree(FULL_PATH)

        if len(os.listdir(FULL_PATH_2)) == 0:
            os.rmdir(FULL_PATH_2)

        if len(os.listdir(FULL_PATH_1)) == 0:
            os.rmdir(FULL_PATH_1)






