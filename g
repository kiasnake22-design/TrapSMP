package com.example.forcefield;

import net.minecraftforge.fml.common.Mod;
import net.minecraftforge.common.MinecraftForge;

@Mod(ForceFieldMod.MODID)
public class ForceFieldMod {
    public static final String MODID = "forcefield";

    public ForceFieldMod() {
        MinecraftForge.EVENT_BUS.register(new ForceFieldHandler());
    }
}
package com.example.forcefield;

import net.minecraft.world.entity.player.Player;
import net.minecraft.world.entity.Mob;
import net.minecraft.world.phys.Vec3;
import net.minecraftforge.event.TickEvent;
import net.minecraftforge.eventbus.api.SubscribeEvent;

public class ForceFieldHandler {

    private static final double RADIUS = 4.0;
    private static final double PUSH_STRENGTH = 1.2;

    @SubscribeEvent
    public void onPlayerTick(TickEvent.PlayerTickEvent event) {
        if (event.phase != TickEvent.Phase.END) return;

        Player player = event.player;
        if (player.level().isClientSide) return;

        var mobs = player.level().getEntitiesOfClass(
                Mob.class,
                player.getBoundingBox().inflate(RADIUS)
        );

        for (Mob mob : mobs) {
            Vec3 direction = mob.position().subtract(player.position());
            double distance = direction.length();

            if (distance < RADIUS && distance > 0.1) {
                Vec3 push = direction.normalize().scale(PUSH_STRENGTH);
                mob.setDeltaMovement(mob.getDeltaMovement().add(push));
                mob.hurtMarked = true;
            }
        }
    }
}
modLoader="javafml"
loaderVersion="[51,)"
license="MIT"

[[mods]]
modId="forcefield"
version="1.0"
displayName="Force Field Mod"
description="Adds a simple force field around the player."
