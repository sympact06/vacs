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


class TicketHandler(commands.Cog):
    def __init__(self, bot):
        self.bot = bot

    @nextcord.slash_command(name="buy", description="Buy vACS")
    async def buy(
        self,
        inter: nextcord.Interaction,
        reason: str = nextcord.SlashOption(
            name="reason",
            description="The reason for opening the ticket",
            required=True,
        ),
        roblox_id: int = nextcord.SlashOption(
            "roblox_id", description="Your personal ROBLOX ID", required=True
        ),
        payment: str = nextcord.SlashOption(
            name="payment_method",
            description="How do you want to pay?",
            choices=["Tikkie", "Crypto", "Robux"],
            required=True,
        ),
    ):
        channel = nextcord.utils.get(inter.guild.channels, id=1094335467513720913)
        newChannel = await channel.create_text_channel(f"buy-{inter.user.name}")
        await newChannel.set_permissions(
            inter.user, read_messages=True, send_messages=True
        )
        await newChannel.set_permissions(inter.guild.default_role, view_channel=False)
        await newChannel.edit(topic=f"{inter.user.id}")

        infoEmbed = nextcord.Embed(description="vACS Ticket System").add_field(
            name=inter.user.name, value=f"Reason: `{reason}`\nROBLOX: `{roblox_id}`"
        )
        paymentEmbed = (
            nextcord.Embed()
            .add_field(
                name="Payment",
                value="We use 3 methods for payment.\n> <:Robux:1096019150796767242> ROBUX\n> <:btc:1096019082593177720> Crypto\n> <:Tikkie1:1096019021352161312> Tikkie",
            )
            .add_field(name="User Payment", value=payment)
        )

        await newChannel.send(embeds=[infoEmbed, paymentEmbed], content="@everyone")

        await inter.send(content=newChannel.mention, ephemeral=True)

    @nextcord.slash_command(name="renew", description="Renew your vACS")
    async def renew(
        self,
        inter: nextcord.Interaction,
        reason: str = nextcord.SlashOption(
            name="reason",
            description="The reason for opening the ticket",
            required=True,
        ),
        roblox_id: int = nextcord.SlashOption(
            "roblox_id", description="Your personal ROBLOX ID", required=True
        ),
        payment: str = nextcord.SlashOption(
            name="payment_method",
            description="How do you want to pay?",
            choices=["Tikkie", "Crypto", "Robux"],
            required=True,
        ),
    ):
        channel = nextcord.utils.get(inter.guild.channels, id=1094335467513720913)
        newChannel = await channel.create_text_channel(f"renew-{inter.user.name}")
        await newChannel.set_permissions(
            inter.user, read_messages=True, send_messages=True
        )
        await newChannel.set_permissions(inter.guild.default_role, view_channel=False)
        await newChannel.edit(topic=f"{inter.user.id}")

        infoEmbed = nextcord.Embed(description="vACS Ticket System").add_field(
            name=inter.user.name, value=f"Reason: `{reason}`\nROBLOX: `{roblox_id}`"
        )
        paymentEmbed = (
            nextcord.Embed()
            .add_field(
                name="Payment",
                value="We use 3 methods for payment.\n> <:Robux:1096019150796767242> ROBUX\n> <:btc:1096019082593177720> Crypto\n> <:Tikkie1:1096019021352161312> Tikkie",
            )
            .add_field(name="User Payment", value=payment)
        )

        await newChannel.send(embeds=[infoEmbed, paymentEmbed], content="@everyone")

        await inter.send(content=newChannel.mention, ephemeral=True)

    @nextcord.slash_command(name="appeal", description="Appeal your vACS ban")
    async def appeal(
        self,
        inter: nextcord.Interaction,
        reason: str = nextcord.SlashOption(
            name="reason",
            description="The reason for opening the ticket",
            required=True,
        ),
        roblox_id: int = nextcord.SlashOption(
            "roblox_id", description="Your personal ROBLOX ID", required=True
        ),
    ):
        channel = nextcord.utils.get(inter.guild.channels, id=1094335467513720913)
        newChannel = await channel.create_text_channel(f"appeal-{inter.user.name}")
        await newChannel.set_permissions(
            inter.user, read_messages=True, send_messages=True
        )
        await newChannel.set_permissions(inter.guild.default_role, view_channel=False)
        await newChannel.edit(topic=f"{inter.user.id}")

        infoEmbed = nextcord.Embed(description="vACS Ticket System").add_field(
            name=inter.user.name,
            value=f"**APPEAL**Reason: `{reason}`\nROBLOX: `{roblox_id}`",
        )
        await newChannel.send(embed=infoEmbed, content="@everyone")

        await inter.send(content=newChannel.mention, ephemeral=True)


def setup(bot):
    bot.add_cog(TicketHandler(bot))
