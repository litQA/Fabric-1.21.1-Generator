<#-- @formatter:off -->
package ${package}.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Mutable;
import org.spongepowered.asm.mixin.gen.Accessor;

@Mixin(AttributeSupplier.class)
public interface AttributeSupplierAccessor {

	@Accessor("instances") @Mutable
	Map<Holder<Attribute>, AttributeInstance> getInstances();
}
<#-- @formatter:on -->
