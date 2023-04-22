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


from concurrent.futures import ThreadPoolExecutor
from os import name
from nextcord.ext import commands
import nextcord, asyncio, requests


class BanHandler(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

    @nextcord.slash_command(description="Ban Handler")
    async def ban(self, interaction: nextcord.Interaction):
        pass

    @ban.subcommand(description="View someones ban")
    async def view(
        self,
        interaction: nextcord.Interaction,
        roblox: int = nextcord.SlashOption(name="roblox_id"),
    ):
        req = requests.get(
            "https://api.domain.com/v1/roblox/vacs/blacklist/get",
            json={"token": "SECRET", "rbxid": f"{roblox}"},
        )

        data = req.json()

        if data["success"]:
            data = data["ban_data"]
            embed = nextcord.Embed(title=data["rbxid"] + " | " + data["ban_type"])
            embed.add_field(name="Reason", value=data["reason"])
            embed.set_footer(text="Banned at " + data["banned_at"])

            await interaction.send(embed=embed, ephemeral=True)
        else:
            await interaction.send(content="User is not banned on vACS", ephemeral=True)

    @ban.subcommand(description="Add ban to user")
    async def add(
        self,
        interaction: nextcord.Interaction,
        type: str = nextcord.SlashOption(
            name="type",
            description="The type of ban given",
            choices=["A", "B", "C"],
            required=True,
        ),
        rs: str = nextcord.SlashOption(name="reason", required=True),
        id: int = nextcord.SlashOption(name="roblox_id", description="The ROBLOX id"),
    ):
        if interaction.user.guild_permissions.ban_members:
            req = requests.post(
                "https://api.domain.com/v1/roblox/vacs/blacklist/add",
                json={
                    "token": "SECRET",
                    "ban_type": type,
                    "reason": rs,
                    "rbxid": f"{id}",
                },
            )
            await interaction.send(content=req.json()["message"], ephemeral=True)
        else:
            await interaction.send(
                content="You do not have permission to use this command", ephemeral=True
            )

    @ban.subcommand(description="Remove ban from user")
    async def remove(
        self,
        interaction: nextcord.Interaction,
        type: int = nextcord.SlashOption(name="roblox_id", required=True),
    ):
        if interaction.user.guild_permissions.ban_members:
            req = requests.post(
                "https://api.domain.com/v1/roblox/vacs/blacklist/remove",
                json={"token": "SECRET", "rbxid": f"{type}"},
            )
            await interaction.send(content=req.json()["message"], ephemeral=True)
        else:
            await interaction.send(
                content="You do not have permission to use this command", ephemeral=True
            )


def setup(bot):
    bot.add_cog(BanHandler(bot))
