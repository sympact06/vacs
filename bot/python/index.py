""" 
 * vACS Project
 * Copyright (C) 2020-2023 Sympact06 & Stuncs69 & TheJordinator
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * For more information about the vACS Project, visit:
 * https://github.com/sympact06/vacs
 
 """


import nextcord
import os
from nextcord.ext import commands


class VacsBot(commands.Bot):
    def __init__(self, command_prefix, **options):
        super().__init__(command_prefix, **options)

    async def on_ready(self):
        print(f'[!] [VACS] {self.user} MARKED AS ONLINE')

    def load_extensions(self, path):
        for x in os.listdir(path):
            if x.endswith(".py"):
                self.load_extension(f"{path}.{x[:-3]}")


if __name__ == '__main__':
    bot = VacsBot(command_prefix='!', description='vACS bot')

    bot.load_extensions('commands')
    bot.run('DISCORD_TOKEN')
