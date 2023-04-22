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



from nextcord.ext import commands
import nextcord, asyncio, aiohttp
import math


def calculate_robux(price_in_euros):
    if price_in_euros is None or price_in_euros <= 0:
        print("Geen integer gegeven")
        return None
    else:
        robux_price = math.ceil(price_in_euros / 0.007518796992481203)
        return robux_price


class UtilHandler(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

    @nextcord.slash_command(name="calc")
    async def calc(
        self,
        interaction: nextcord.Interaction,
        amount: int = nextcord.SlashOption(
            name="visits", description="The amount of visits"
        ),
    ):
        if interaction.user.guild_permissions.ban_members:
            price = calculate_robux(amount)
            await interaction.send(f"EUR: {price}")
        else:
            await interaction.send("You are not permitted to utilize this command.")


def setup(bot):
    bot.add_cog(UtilHandler(bot))
