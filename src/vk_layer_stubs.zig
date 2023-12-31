const vk = @import("vulkan-zig");


pub const LayerInstanceLink = extern struct {
    p_next: *LayerInstanceLink,
    pfn_next_get_instance_proc_addr: vk.PfnGetInstanceProcAddr,
};
pub const PfnSetInstanceLoaderData = ?*const fn (vk.Instance, ?*anyopaque) callconv(.C) vk.Result;
const union_unnamed_1 = extern union {
    p_layer_info: *LayerInstanceLink,
    pfn_set_instance_loader_data: PfnSetInstanceLoaderData,
};
pub const LayerFunction = c_int;
pub const LayerFunction_LAYER_LINK_INFO: c_int = 0;
pub const LayerFunction_LOADER_DATA_CALLBACK: c_int = 1;
pub const LayerInstanceCreateInfo = extern struct {
    s_type: vk.StructureType,
    p_next: ?*const anyopaque,
    function: LayerFunction,
    u: union_unnamed_1,
};

pub const LayerDeviceLink = extern struct {
    p_next: *LayerDeviceLink,
    pfn_next_get_instance_proc_addr: vk.PfnGetInstanceProcAddr,
    pfn_next_get_device_proc_addr: vk.PfnGetDeviceProcAddr,
};
pub const PfnSetDeviceLoaderData = ?*const fn (vk.Device, ?*anyopaque) callconv(vk.vulkan_call_conv) vk.Result;
const union_unnamed_2 = extern union {
    p_layer_info: *LayerDeviceLink,
    pfn_set_device_loader_data: PfnSetDeviceLoaderData,
};
pub const LayerDeviceCreateInfo = extern struct {
    s_type: vk.StructureType,
    p_next: ?*const anyopaque,
    function: LayerFunction,
    u: union_unnamed_2,
};

pub const LayerInstanceDispatchTable = extern struct {
    GetInstanceProcAddr: vk.PfnGetInstanceProcAddr,
    DestroyInstance: vk.PfnDestroyInstance,
    EnumeratePhysicalDevices: vk.PfnEnumeratePhysicalDevices,
    GetPhysicalDeviceFeatures: vk.PfnGetPhysicalDeviceFeatures,
    GetPhysicalDeviceImageFormatProperties: vk.PfnGetPhysicalDeviceImageFormatProperties,
    GetPhysicalDeviceFormatProperties: vk.PfnGetPhysicalDeviceFormatProperties,
    GetPhysicalDeviceSparseImageFormatProperties: vk.PfnGetPhysicalDeviceSparseImageFormatProperties,
    GetPhysicalDeviceProperties: vk.PfnGetPhysicalDeviceProperties,
    GetPhysicalDeviceQueueFamilyProperties: vk.PfnGetPhysicalDeviceQueueFamilyProperties,
    GetPhysicalDeviceMemoryProperties: vk.PfnGetPhysicalDeviceMemoryProperties,
    EnumerateDeviceExtensionProperties: vk.PfnEnumerateDeviceExtensionProperties,
    EnumerateDeviceLayerProperties: vk.PfnEnumerateDeviceLayerProperties,
    DestroySurfaceKHR: vk.PfnDestroySurfaceKHR,
    GetPhysicalDeviceSurfaceSupportKHR: vk.PfnGetPhysicalDeviceSurfaceSupportKHR,
    GetPhysicalDeviceSurfaceCapabilitiesKHR: vk.PfnGetPhysicalDeviceSurfaceCapabilitiesKHR,
    GetPhysicalDeviceSurfaceFormatsKHR: vk.PfnGetPhysicalDeviceSurfaceFormatsKHR,
    GetPhysicalDeviceSurfacePresentModesKHR: vk.PfnGetPhysicalDeviceSurfacePresentModesKHR,
    CreateDebugReportCallbackEXT: vk.PfnCreateDebugReportCallbackEXT,
    DestroyDebugReportCallbackEXT: vk.PfnDestroyDebugReportCallbackEXT,
    DebugReportMessageEXT: vk.PfnDebugReportMessageEXT,
    GetPhysicalDeviceDisplayPropertiesKHR: vk.PfnGetPhysicalDeviceDisplayPropertiesKHR,
    GetPhysicalDeviceDisplayPlanePropertiesKHR: vk.PfnGetPhysicalDeviceDisplayPlanePropertiesKHR,
    GetDisplayPlaneSupportedDisplaysKHR: vk.PfnGetDisplayPlaneSupportedDisplaysKHR,
    GetDisplayModePropertiesKHR: vk.PfnGetDisplayModePropertiesKHR,
    CreateDisplayModeKHR: vk.PfnCreateDisplayModeKHR,
    GetDisplayPlaneCapabilitiesKHR: vk.PfnGetDisplayPlaneCapabilitiesKHR,
    CreateDisplayPlaneSurfaceKHR: vk.PfnCreateDisplayPlaneSurfaceKHR,
    GetPhysicalDeviceExternalImageFormatPropertiesNV: vk.PfnGetPhysicalDeviceExternalImageFormatPropertiesNV,
};

pub const LayerDispatchTable = extern struct {
    GetDeviceProcAddr: vk.PfnGetDeviceProcAddr,
    DestroyDevice: vk.PfnDestroyDevice,
    GetDeviceQueue: vk.PfnGetDeviceQueue,
    QueueSubmit: vk.PfnQueueSubmit,
    QueueWaitIdle: vk.PfnQueueWaitIdle,
    DeviceWaitIdle: vk.PfnDeviceWaitIdle,
    AllocateMemory: vk.PfnAllocateMemory,
    FreeMemory: vk.PfnFreeMemory,
    MapMemory: vk.PfnMapMemory,
    UnmapMemory: vk.PfnUnmapMemory,
    FlushMappedMemoryRanges: vk.PfnFlushMappedMemoryRanges,
    InvalidateMappedMemoryRanges: vk.PfnInvalidateMappedMemoryRanges,
    GetDeviceMemoryCommitment: vk.PfnGetDeviceMemoryCommitment,
    GetImageSparseMemoryRequirements: vk.PfnGetImageSparseMemoryRequirements,
    GetImageMemoryRequirements: vk.PfnGetImageMemoryRequirements,
    GetBufferMemoryRequirements: vk.PfnGetBufferMemoryRequirements,
    BindImageMemory: vk.PfnBindImageMemory,
    BindBufferMemory: vk.PfnBindBufferMemory,
    QueueBindSparse: vk.PfnQueueBindSparse,
    CreateFence: vk.PfnCreateFence,
    DestroyFence: vk.PfnDestroyFence,
    GetFenceStatus: vk.PfnGetFenceStatus,
    ResetFences: vk.PfnResetFences,
    WaitForFences: vk.PfnWaitForFences,
    CreateSemaphore: vk.PfnCreateSemaphore,
    DestroySemaphore: vk.PfnDestroySemaphore,
    CreateEvent: vk.PfnCreateEvent,
    DestroyEvent: vk.PfnDestroyEvent,
    GetEventStatus: vk.PfnGetEventStatus,
    SetEvent: vk.PfnSetEvent,
    ResetEvent: vk.PfnResetEvent,
    CreateQueryPool: vk.PfnCreateQueryPool,
    DestroyQueryPool: vk.PfnDestroyQueryPool,
    GetQueryPoolResults: vk.PfnGetQueryPoolResults,
    CreateBuffer: vk.PfnCreateBuffer,
    DestroyBuffer: vk.PfnDestroyBuffer,
    CreateBufferView: vk.PfnCreateBufferView,
    DestroyBufferView: vk.PfnDestroyBufferView,
    CreateImage: vk.PfnCreateImage,
    DestroyImage: vk.PfnDestroyImage,
    GetImageSubresourceLayout: vk.PfnGetImageSubresourceLayout,
    CreateImageView: vk.PfnCreateImageView,
    DestroyImageView: vk.PfnDestroyImageView,
    CreateShaderModule: vk.PfnCreateShaderModule,
    DestroyShaderModule: vk.PfnDestroyShaderModule,
    CreatePipelineCache: vk.PfnCreatePipelineCache,
    DestroyPipelineCache: vk.PfnDestroyPipelineCache,
    GetPipelineCacheData: vk.PfnGetPipelineCacheData,
    MergePipelineCaches: vk.PfnMergePipelineCaches,
    CreateGraphicsPipelines: vk.PfnCreateGraphicsPipelines,
    CreateComputePipelines: vk.PfnCreateComputePipelines,
    DestroyPipeline: vk.PfnDestroyPipeline,
    CreatePipelineLayout: vk.PfnCreatePipelineLayout,
    DestroyPipelineLayout: vk.PfnDestroyPipelineLayout,
    CreateSampler: vk.PfnCreateSampler,
    DestroySampler: vk.PfnDestroySampler,
    CreateDescriptorSetLayout: vk.PfnCreateDescriptorSetLayout,
    DestroyDescriptorSetLayout: vk.PfnDestroyDescriptorSetLayout,
    CreateDescriptorPool: vk.PfnCreateDescriptorPool,
    DestroyDescriptorPool: vk.PfnDestroyDescriptorPool,
    ResetDescriptorPool: vk.PfnResetDescriptorPool,
    AllocateDescriptorSets: vk.PfnAllocateDescriptorSets,
    FreeDescriptorSets: vk.PfnFreeDescriptorSets,
    UpdateDescriptorSets: vk.PfnUpdateDescriptorSets,
    CreateFramebuffer: vk.PfnCreateFramebuffer,
    DestroyFramebuffer: vk.PfnDestroyFramebuffer,
    CreateRenderPass: vk.PfnCreateRenderPass,
    DestroyRenderPass: vk.PfnDestroyRenderPass,
    GetRenderAreaGranularity: vk.PfnGetRenderAreaGranularity,
    CreateCommandPool: vk.PfnCreateCommandPool,
    DestroyCommandPool: vk.PfnDestroyCommandPool,
    ResetCommandPool: vk.PfnResetCommandPool,
    AllocateCommandBuffers: vk.PfnAllocateCommandBuffers,
    FreeCommandBuffers: vk.PfnFreeCommandBuffers,
    BeginCommandBuffer: vk.PfnBeginCommandBuffer,
    EndCommandBuffer: vk.PfnEndCommandBuffer,
    ResetCommandBuffer: vk.PfnResetCommandBuffer,
    CmdBindPipeline: vk.PfnCmdBindPipeline,
    CmdBindDescriptorSets: vk.PfnCmdBindDescriptorSets,
    CmdBindVertexBuffers: vk.PfnCmdBindVertexBuffers,
    CmdBindIndexBuffer: vk.PfnCmdBindIndexBuffer,
    CmdSetViewport: vk.PfnCmdSetViewport,
    CmdSetScissor: vk.PfnCmdSetScissor,
    CmdSetLineWidth: vk.PfnCmdSetLineWidth,
    CmdSetDepthBias: vk.PfnCmdSetDepthBias,
    CmdSetBlendConstants: vk.PfnCmdSetBlendConstants,
    CmdSetDepthBounds: vk.PfnCmdSetDepthBounds,
    CmdSetStencilCompareMask: vk.PfnCmdSetStencilCompareMask,
    CmdSetStencilWriteMask: vk.PfnCmdSetStencilWriteMask,
    CmdSetStencilReference: vk.PfnCmdSetStencilReference,
    CmdDraw: vk.PfnCmdDraw,
    CmdDrawIndexed: vk.PfnCmdDrawIndexed,
    CmdDrawIndirect: vk.PfnCmdDrawIndirect,
    CmdDrawIndexedIndirect: vk.PfnCmdDrawIndexedIndirect,
    CmdDispatch: vk.PfnCmdDispatch,
    CmdDispatchIndirect: vk.PfnCmdDispatchIndirect,
    CmdCopyBuffer: vk.PfnCmdCopyBuffer,
    CmdCopyImage: vk.PfnCmdCopyImage,
    CmdBlitImage: vk.PfnCmdBlitImage,
    CmdCopyBufferToImage: vk.PfnCmdCopyBufferToImage,
    CmdCopyImageToBuffer: vk.PfnCmdCopyImageToBuffer,
    CmdUpdateBuffer: vk.PfnCmdUpdateBuffer,
    CmdFillBuffer: vk.PfnCmdFillBuffer,
    CmdClearColorImage: vk.PfnCmdClearColorImage,
    CmdClearDepthStencilImage: vk.PfnCmdClearDepthStencilImage,
    CmdClearAttachments: vk.PfnCmdClearAttachments,
    CmdResolveImage: vk.PfnCmdResolveImage,
    CmdSetEvent: vk.PfnCmdSetEvent,
    CmdResetEvent: vk.PfnCmdResetEvent,
    CmdWaitEvents: vk.PfnCmdWaitEvents,
    CmdPipelineBarrier: vk.PfnCmdPipelineBarrier,
    CmdBeginQuery: vk.PfnCmdBeginQuery,
    CmdEndQuery: vk.PfnCmdEndQuery,
    CmdResetQueryPool: vk.PfnCmdResetQueryPool,
    CmdWriteTimestamp: vk.PfnCmdWriteTimestamp,
    CmdCopyQueryPoolResults: vk.PfnCmdCopyQueryPoolResults,
    CmdPushConstants: vk.PfnCmdPushConstants,
    CmdBeginRenderPass: vk.PfnCmdBeginRenderPass,
    CmdNextSubpass: vk.PfnCmdNextSubpass,
    CmdEndRenderPass: vk.PfnCmdEndRenderPass,
    CmdExecuteCommands: vk.PfnCmdExecuteCommands,
    CreateSwapchainKHR: vk.PfnCreateSwapchainKHR,
    DestroySwapchainKHR: vk.PfnDestroySwapchainKHR,
    GetSwapchainImagesKHR: vk.PfnGetSwapchainImagesKHR,
    AcquireNextImageKHR: vk.PfnAcquireNextImageKHR,
    QueuePresentKHR: vk.PfnQueuePresentKHR,
    CmdDrawIndirectCountAMD: vk.PfnCmdDrawIndirectCountAMD,
    CmdDrawIndexedIndirectCountAMD: vk.PfnCmdDrawIndexedIndirectCountAMD,
    CreateSharedSwapchainsKHR: vk.PfnCreateSharedSwapchainsKHR,
    DebugMarkerSetObjectTagEXT: vk.PfnDebugMarkerSetObjectTagEXT,
    DebugMarkerSetObjectNameEXT: vk.PfnDebugMarkerSetObjectNameEXT,
    CmdDebugMarkerBeginEXT: vk.PfnCmdDebugMarkerBeginEXT,
    CmdDebugMarkerEndEXT: vk.PfnCmdDebugMarkerEndEXT,
    CmdDebugMarkerInsertEXT: vk.PfnCmdDebugMarkerInsertEXT,
};
