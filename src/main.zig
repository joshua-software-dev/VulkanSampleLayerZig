const std = @import("std");
const vk = @import("vulkan-zig");
const vk_layer_stubs = @import("vk_layer_stubs.zig");

const CommandStats = extern struct {
    draw_count: u32,
    instance_count: u32,
    vert_count: u32
};
const LAYER_NAME = "VK_LAYER_SAMPLE_SampleLayerZig";

var command_buffer_stats = std.AutoHashMap(vk.CommandBuffer, CommandStats).init(std.heap.c_allocator);
var device_dispatcher: ?vk_layer_stubs.LayerDispatchTable = null;
var global_lock: std.Thread.Mutex = .{};
var instance_dispatcher: ?vk_layer_stubs.LayerInstanceDispatchTable = null;


export fn SampleLayerZig_CreateInstance
(
    p_create_info: *const vk.InstanceCreateInfo,
    p_allocator: ?*const vk.AllocationCallbacks,
    p_instance: *vk.Instance
)
callconv(vk.vulkan_call_conv) vk.Result
{
    var layer_create_info: ?*vk_layer_stubs.LayerInstanceCreateInfo = @ptrCast
    (
        @alignCast(@constCast(p_create_info.p_next))
    );

    // step through the chain of p_next until we get to the link info
    while
    (
        layer_create_info != null and
        (
            layer_create_info.?.s_type != vk.StructureType.loader_instance_create_info or
            layer_create_info.?.function != vk_layer_stubs.LayerFunction_LAYER_LINK_INFO
        )
    )
    {
        layer_create_info = @ptrCast(@alignCast(@constCast(layer_create_info.?.p_next)));
    }

    if(layer_create_info == null)
    {
        // No loader instance create info
        return vk.Result.error_initialization_failed;
    }

    var final_layer_create_info: *vk_layer_stubs.LayerDeviceCreateInfo = @ptrCast(layer_create_info orelse unreachable);
    var gpa: vk.PfnGetInstanceProcAddr = final_layer_create_info.u.p_layer_info.pfn_next_get_instance_proc_addr;
    // move chain on for next layer
    final_layer_create_info.u.p_layer_info = final_layer_create_info.u.p_layer_info.p_next;

    const createFunc: vk.PfnCreateInstance = @ptrCast(gpa(vk.Instance.null_handle, "vkCreateInstance"));
    _ = createFunc(p_create_info, p_allocator, p_instance);

    // fetch our own dispatch table for the functions we need, into the next layer
    var dispatch_table: vk_layer_stubs.LayerInstanceDispatchTable = undefined;
    dispatch_table.GetInstanceProcAddr = @ptrCast(gpa(p_instance.*, "vkGetInstanceProcAddr"));
    dispatch_table.DestroyInstance = @ptrCast(gpa(p_instance.*, "vkDestroyInstance"));
    dispatch_table.EnumerateDeviceExtensionProperties = @ptrCast(gpa(p_instance.*, "vkEnumerateDeviceExtensionProperties"));

    global_lock.lock();
    defer global_lock.unlock();
    instance_dispatcher = dispatch_table;

    return vk.Result.success;
}

export fn SampleLayerZig_DestroyInstance
(
    instance: vk.Instance,
    p_allocator: ?*const vk.AllocationCallbacks
)
callconv(vk.vulkan_call_conv) void
{
    _ = instance;
    _ = p_allocator;
    global_lock.lock();
    defer global_lock.unlock();
    instance_dispatcher = null;
}

export fn SampleLayerZig_CreateDevice
(
    physical_device: vk.PhysicalDevice,
    p_create_info: *const vk.DeviceCreateInfo,
    p_allocator: ?*const vk.AllocationCallbacks,
    p_device: *vk.Device
)
callconv(vk.vulkan_call_conv) vk.Result
{
    var layer_create_info: ?*vk_layer_stubs.LayerDeviceCreateInfo = @ptrCast
    (
        @alignCast(@constCast(p_create_info.p_next))
    );

    // step through the chain of p_next until we get to the link info
    while
    (
        layer_create_info != null and
        (
            layer_create_info.?.s_type != vk.StructureType.loader_device_create_info or
            layer_create_info.?.function != vk_layer_stubs.LayerFunction_LAYER_LINK_INFO
        )
    )
    {
        layer_create_info = @ptrCast(@alignCast(@constCast(layer_create_info.?.p_next)));
    }

    if(layer_create_info == null)
    {
        // No loader instance create info
        return vk.Result.error_initialization_failed;
    }

    var final_layer_create_info: *vk_layer_stubs.LayerDeviceCreateInfo = @ptrCast(layer_create_info orelse unreachable);
    var gipa: vk.PfnGetInstanceProcAddr = final_layer_create_info.u.p_layer_info.pfn_next_get_instance_proc_addr;
    var gdpa: vk.PfnGetDeviceProcAddr = final_layer_create_info.u.p_layer_info.pfn_next_get_device_proc_addr;
    // move chain on for next layer
    final_layer_create_info.u.p_layer_info = final_layer_create_info.u.p_layer_info.p_next;

    const createFunc: vk.PfnCreateDevice = @ptrCast(gipa(vk.Instance.null_handle, "vkCreateDevice"));
    _ = createFunc(physical_device, p_create_info, p_allocator, p_device);

    // fetch our own dispatch table for the functions we need, into the next layer
    var dispatch_table: vk_layer_stubs.LayerDispatchTable = undefined;
    dispatch_table.GetDeviceProcAddr = @ptrCast(gdpa(p_device.*, "vkGetDeviceProcAddr"));
    dispatch_table.DestroyDevice = @ptrCast(gdpa(p_device.*, "vkDestroyDevice"));
    dispatch_table.BeginCommandBuffer = @ptrCast(gdpa(p_device.*, "vkBeginCommandBuffer"));
    dispatch_table.CmdDraw = @ptrCast(gdpa(p_device.*, "vkCmdDraw"));
    dispatch_table.CmdDrawIndexed = @ptrCast(gdpa(p_device.*, "vkCmdDrawIndexed"));
    dispatch_table.EndCommandBuffer = @ptrCast(gdpa(p_device.*, "vkEndCommandBuffer"));

    global_lock.lock();
    defer global_lock.unlock();
    device_dispatcher = dispatch_table;

    return vk.Result.success;
}

export fn SampleLayerZig_DestroyDevice
(
    device: vk.Device,
    p_allocator: ?*const vk.AllocationCallbacks
)
callconv(vk.vulkan_call_conv) void
{
    _ = device;
    _ = p_allocator;
    global_lock.lock();
    defer global_lock.unlock();
    device_dispatcher = null;
}

export fn SampleLayerZig_BeginCommandBuffer
(
    command_buffer: vk.CommandBuffer,
    p_begin_info: *const vk.CommandBufferBeginInfo
)
callconv(vk.vulkan_call_conv) vk.Result
{
    var stats: CommandStats = .{ .draw_count = 0, .instance_count = 0, .vert_count = 0 };

    command_buffer_stats.put(command_buffer, stats) catch @panic("BeginCommandBuffer failed to save stats table");

    global_lock.lock();
    defer global_lock.unlock();
    const table = device_dispatcher orelse @panic("BeginCommandBuffer failed to get dispatch table");
    return table.BeginCommandBuffer(command_buffer, p_begin_info);
}

export fn SampleLayerZig_CmdDraw
(
    command_buffer: vk.CommandBuffer,
    vertex_count: u32,
    instance_count: u32,
    first_vertex: u32,
    first_instance: u32
)
callconv(vk.vulkan_call_conv) void
{
    global_lock.lock();
    defer global_lock.unlock();

    var stats = command_buffer_stats.get(command_buffer) orelse @panic("CmdDraw failed to get command buffer stats");
    stats.draw_count += 1;
    stats.instance_count += instance_count;
    stats.vert_count += instance_count * vertex_count;
    command_buffer_stats.put(command_buffer, stats) catch @panic("SampleLayerZig_CmdDraw failed to save stats table");

    const table = device_dispatcher orelse @panic("CmdDraw failed to get dispatch table");
    table.CmdDraw(command_buffer, vertex_count, instance_count, first_vertex, first_instance);
}

export fn SampleLayerZig_CmdDrawIndexed
(
    command_buffer: vk.CommandBuffer,
    index_count: u32,
    instance_count: u32,
    first_index: u32,
    vertex_offset: i32,
    first_instance: u32
)
callconv(vk.vulkan_call_conv) void
{
    global_lock.lock();
    defer global_lock.unlock();

    var stats = command_buffer_stats.get(command_buffer) orelse @panic("CmdDrawIndexed failed to get command buffer stats");
    stats.draw_count += 1;
    stats.instance_count += instance_count;
    stats.vert_count += instance_count * index_count;
    command_buffer_stats.put(command_buffer, stats) catch @panic("SampleLayerZig_CmdDrawIndexed failed to save stats table");

    const table = device_dispatcher orelse @panic("CmdDrawIndexed failed to get dispatch table");
    table.CmdDrawIndexed(command_buffer, index_count, instance_count, first_index, vertex_offset, first_instance);
}

export fn SampleLayerZig_EndCommandBuffer
(
    command_buffer: vk.CommandBuffer
)
callconv(vk.vulkan_call_conv) vk.Result
{
    global_lock.lock();
    defer global_lock.unlock();
    var stats: ?CommandStats = command_buffer_stats.get(command_buffer) orelse @panic("CmdDraw failed to get command buffer stats");
    if (stats != null)
    {
        std.debug.print
        (
            "Command buffer {} ended with {} draws, {} instances and {} vertices\n",
            .{
                &command_buffer,
                stats.?.draw_count,
                stats.?.instance_count,
                stats.?.vert_count
            }
        );
    }
    else
    {
        std.debug.print("WARNING: EndCommandBuffer failed to get command buffer stats\n", .{});
    }

    const table = device_dispatcher orelse @panic("EndCommandBuffer failed to get dispatch table");
    return table.EndCommandBuffer(command_buffer);
}

export fn SampleLayerZig_EnumerateInstanceLayerProperties
(
    p_property_count: *u32,
    p_properties: ?*vk.LayerProperties
)
callconv(vk.vulkan_call_conv) vk.Result
{
    p_property_count.* = 1;

    if (p_properties != null)
    {
        var props: *vk.LayerProperties = @ptrCast(p_properties);
        const temp_layer_name: *[vk.MAX_DESCRIPTION_SIZE]u8 = @ptrCast(@constCast(LAYER_NAME));
        @memcpy
        (
            &props.layer_name,
            temp_layer_name
        );

        const temp_layer_desc: *[vk.MAX_DESCRIPTION_SIZE]u8 = @ptrCast
        (
            @constCast("Sample layer - https://renderdoc.org/vulkan-layer-guide.html")
        );
        @memcpy
        (
            &props.description,
            temp_layer_desc
        );

        props.implementation_version = 1;
        props.spec_version = vk.API_VERSION_1_0;
    }

    return vk.Result.success;
}

export fn SampleLayerZig_EnumerateDeviceLayerProperties
(
    physical_device: vk.PhysicalDevice,
    p_property_count: *u32,
    p_properties: ?*vk.LayerProperties
)
callconv(vk.vulkan_call_conv) vk.Result
{
    _ = physical_device;
    return SampleLayerZig_EnumerateInstanceLayerProperties(p_property_count, p_properties);
}

export fn SampleLayerZig_EnumerateInstanceExtensionProperties
(
    p_layer_name: ?[*:0]const u8,
    p_property_count: *u32,
    p_properties: ?[*]vk.ExtensionProperties
)
callconv(vk.vulkan_call_conv) vk.Result
{
    _ = p_properties;
    const span_name = std.mem.span(p_layer_name) orelse "";
    if (p_layer_name == null or !std.mem.eql(u8, span_name, LAYER_NAME))
    {
        return vk.Result.error_layer_not_present;
    }

    // don't expose any extensions
    p_property_count.* = 0;
    return vk.Result.success;
}

export fn SampleLayerZig_EnumerateDeviceExtensionProperties
(
    physical_device: vk.PhysicalDevice,
    p_layer_name: ?[*:0]const u8,
    p_property_count: *u32,
    p_properties: ?[*]vk.ExtensionProperties
)
callconv(vk.vulkan_call_conv) vk.Result
{
    const span_name = std.mem.span(p_layer_name) orelse "";
    // pass through any queries that aren't to us
    if (p_layer_name == null or !std.mem.eql(u8, span_name, LAYER_NAME))
    {
        if (physical_device == vk.PhysicalDevice.null_handle) return vk.Result.success;

        global_lock.lock();
        defer global_lock.unlock();
        const table = instance_dispatcher orelse @panic("EnumerateDeviceExtensionProperties failed to get dispatch table");
        return table.EnumerateDeviceExtensionProperties(physical_device, p_layer_name, p_property_count, p_properties);
    }

    // don't expose any extensions
    p_property_count.* = 0;
    return vk.Result.success;
}

fn get_proc_addr(func_name: anytype) vk.PfnVoidFunction
{
    return @ptrCast(@alignCast(&func_name));
}

export fn SampleLayerZig_GetDeviceProcAddr
(
    device: vk.Device,
    p_name: [*:0]const u8
)
callconv(vk.vulkan_call_conv) vk.PfnVoidFunction
{
    const span_name = std.mem.span(p_name);

    // device chain functions we intercept
    if (std.mem.eql(u8, span_name, "vkGetDeviceProcAddr"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_GetDeviceProcAddr));
    }
    else if (std.mem.eql(u8, span_name, "vkEnumerateDeviceLayerProperties"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_EnumerateDeviceLayerProperties));
    }
    else if (std.mem.eql(u8, span_name, "vkEnumerateDeviceExtensionProperties"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_EnumerateDeviceExtensionProperties));
    }
    else if (std.mem.eql(u8, span_name, "vkCreateDevice"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_CreateDevice));
    }
    else if (std.mem.eql(u8, span_name, "vkDestroyDevice"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_DestroyDevice));
    }
    else if (std.mem.eql(u8, span_name, "vkBeginCommandBuffer"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_BeginCommandBuffer));
    }
    else if (std.mem.eql(u8, span_name, "vkCmdDraw"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_CmdDraw));
    }
    else if (std.mem.eql(u8, span_name, "vkCmdDrawIndexed"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_CmdDrawIndexed));
    }
    else if (std.mem.eql(u8, span_name, "vkEndCommandBuffer"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_EndCommandBuffer));
    }

    global_lock.lock();
    defer global_lock.unlock();
    const table = device_dispatcher orelse @panic("GetDeviceProcAddr failed to get dispatch table");
    return @ptrCast(@alignCast(table.GetDeviceProcAddr(device, p_name)));
}

export fn SampleLayerZig_GetInstanceProcAddr
(
    instance: vk.Instance,
    p_name: [*:0]const u8
)
callconv(vk.vulkan_call_conv) vk.PfnVoidFunction
{
    const span_name = std.mem.span(p_name);

    // instance chain functions we intercept
    if (std.mem.eql(u8, span_name, "vkGetInstanceProcAddr"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_GetInstanceProcAddr));
    }
    else if (std.mem.eql(u8, span_name, "vkEnumerateInstanceLayerProperties"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_EnumerateInstanceLayerProperties));
    }
    else if (std.mem.eql(u8, span_name, "vkEnumerateInstanceExtensionProperties"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_EnumerateInstanceExtensionProperties));
    }
    else if (std.mem.eql(u8, span_name, "vkCreateInstance"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_CreateInstance));
    }
    else if (std.mem.eql(u8, span_name, "vkDestroyInstance"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_DestroyInstance));
    }

    // device chain functions we intercept
    if (std.mem.eql(u8, span_name, "vkGetDeviceProcAddr"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_GetDeviceProcAddr));
    }
    else if (std.mem.eql(u8, span_name, "vkEnumerateDeviceLayerProperties"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_EnumerateDeviceLayerProperties));
    }
    else if (std.mem.eql(u8, span_name, "vkEnumerateDeviceExtensionProperties"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_EnumerateDeviceExtensionProperties));
    }
    else if (std.mem.eql(u8, span_name, "vkCreateDevice"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_CreateDevice));
    }
    else if (std.mem.eql(u8, span_name, "vkDestroyDevice"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_DestroyDevice));
    }
    else if (std.mem.eql(u8, span_name, "vkBeginCommandBuffer"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_BeginCommandBuffer));
    }
    else if (std.mem.eql(u8, span_name, "vkCmdDraw"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_CmdDraw));
    }
    else if (std.mem.eql(u8, span_name, "vkCmdDrawIndexed"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_CmdDrawIndexed));
    }
    else if (std.mem.eql(u8, span_name, "vkEndCommandBuffer"))
    {
        return @ptrCast(@alignCast(&SampleLayerZig_EndCommandBuffer));
    }

    global_lock.lock();
    defer global_lock.unlock();
    const table = instance_dispatcher orelse @panic("GetInstanceProcAddr failed to get dispatch table");
    return @ptrCast(@alignCast(table.GetInstanceProcAddr(instance, p_name)));
}
