// spkg - Sourim Package Manager
// Copyright (C) 2024 r2team
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

#include <linux/limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <dirent.h>
#include <string.h>
#include <unistd.h>
#include <libgen.h>

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "usage pidof <PROGRAM>\n");
        return 1;
    }
    DIR *dir;
    struct dirent *ent;
    if ((dir = opendir ("/proc")) != NULL) {
        while ((ent = readdir(dir)) != NULL) {
            int pid = atoi(ent->d_name);

            if (pid) {
                char path_to_proc[PATH_MAX];
                char path_to_link[PATH_MAX];
                bzero(path_to_link, PATH_MAX);
                bzero(path_to_proc, PATH_MAX);

                strcpy(path_to_proc, "/proc/");
                strcat(path_to_proc, ent->d_name);
                strcat(path_to_proc, "/exe");
                if (readlink(path_to_proc, path_to_link, PATH_MAX) != -1) {
                    char *base = basename(path_to_link);

                    if (!strcmp(argv[1], base))
                        printf("%s ", ent->d_name);
                }
            }
        }
        closedir(dir);
    } else {
        /* could not open directory */
        perror("pidof");
        return EXIT_FAILURE;
    }
    puts("");
}