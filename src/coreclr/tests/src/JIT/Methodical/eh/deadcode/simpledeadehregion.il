// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.
// See the LICENSE file in the project root for more information.
// the simplest dead EH region that will not also have dead nonlocal exit


.assembly extern System.Console
{
  .publickeytoken = (B0 3F 5F 7F 11 D5 0A 3A )
  .ver 4:0:0:0
}
.assembly extern mscorlib
{
  .ver 0:0:0:0
}
.assembly extern common{}
.assembly test
{
  .ver 0:0:0:0
}
.module test.exe
.imagebase 0x00400000
.subsystem 0x00000003
.file alignment 512
.corflags 0x00000001

.method public static int32 main() {
    .entrypoint
    .maxstack  400
    .locals	init (	int32 V_0,
				int32 V_1,
				class [mscorlib]System.IO.StringWriter expectedOut,
				class [common]TestUtil.TestLog testLog
			)

    newobj     instance void [mscorlib]System.IO.StringWriter::.ctor()
    stloc.s    expectedOut
    ldloc.s    expectedOut
    ldstr      "In try"
    callvirt   instance void [mscorlib]System.IO.TextWriter::WriteLine(string)
    ldloc.s    expectedOut
    ldstr      "Done!"
    callvirt   instance void [mscorlib]System.IO.TextWriter::WriteLine(string)
    ldloc.s    expectedOut
    newobj     instance void [common]TestUtil.TestLog::.ctor(object)
    stloc.s    testLog

    ldloc.s    testLog
    callvirt   instance void [common]TestUtil.TestLog::StartRecording()

    ldc.i4     0xffff63c0
    stloc.0

    .try {
        ldstr "In try"
        call void [System.Console]System.Console::WriteLine(class [mscorlib]System.String)
        br.s skip

    .try {
       ldstr "In inner try, unreached"
       call void [System.Console]System.Console::WriteLine(class [mscorlib]System.String)
       x:
       leave.s x
    } finally {
       ldstr "In finally, unreached"
       call void [System.Console]System.Console::WriteLine(class [mscorlib]System.String)
       endfinally
    }

skip:
      leave.s done
    } catch [mscorlib]System.Object {
      ldstr "In catch, unreached"
      call void [System.Console]System.Console::WriteLine(class [mscorlib]System.String)
      leave.s done
    }
    
done: 
		ldstr "Done!"
		call void [System.Console]System.Console::WriteLine(class [mscorlib]System.String)
		ldloc.s    testLog
		callvirt   instance void [common]TestUtil.TestLog::StopRecording()
  
		ldloc.s    testLog
		callvirt   instance int32 [common]TestUtil.TestLog::VerifyOutput()
        ret
}
