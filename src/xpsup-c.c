#include <windows.h>

static HMODULE
GetKernel()
{
   HMODULE mod = GetModuleHandle(L"kernelbase.dll");
   if (!mod)
      mod = GetModuleHandle(L"kernel32.dll");
   return mod;
}

PVOID WINAPI
DecodePointer(PVOID x)
{
   PVOID (WINAPI *fn)(PVOID) =
      (PVOID)GetProcAddress(GetKernel(), "DecodePointer");
   if (fn)
      return fn(x);
   return x;
}

PVOID WINAPI
EncodePointer(PVOID x)
{
   PVOID (WINAPI *fn)(PVOID) = 
      (PVOID)GetProcAddress(GetKernel(), "EncodePointer");
   if (fn)
      return fn(x);
   return x;
}

BOOL WINAPI
GetLogicalProcessorInformation(
   PSYSTEM_LOGICAL_PROCESSOR_INFORMATION Buffer,
   PDWORD ReturnedLength
)
{
   BOOL (WINAPI *fn)(PSYSTEM_LOGICAL_PROCESSOR_INFORMATION, PDWORD) = 
      (PVOID)GetProcAddress(GetKernel(), "GetLogicalProcessorInformation");
   if (fn)
      return fn(Buffer, ReturnedLength);
   SetLastError(ERROR_NOT_SUPPORTED);
   return FALSE;
}
