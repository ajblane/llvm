//===-- AMDGPU.td - AMDGPU Tablegen files --------*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===------------------------------------------------------------===//

include "llvm/Target/Target.td"

//===------------------------------------------------------------===//
// Subtarget Features (device properties)
//===------------------------------------------------------------===//

def FeatureFP64 : SubtargetFeature<"fp64",
  "FP64",
  "true",
  "Enable double precision operations"
>;

def FeatureFastFMAF32 : SubtargetFeature<"fast-fmaf",
  "FastFMAF32",
  "true",
  "Assuming f32 fma is at least as fast as mul + add"
>;

def HalfRate64Ops : SubtargetFeature<"half-rate-64-ops",
  "HalfRate64Ops",
  "true",
  "Most fp64 instructions are half rate instead of quarter"
>;

def FeatureR600ALUInst : SubtargetFeature<"R600ALUInst",
  "R600ALUInst",
  "false",
  "Older version of ALU instructions encoding"
>;

def FeatureVertexCache : SubtargetFeature<"HasVertexCache",
  "HasVertexCache",
  "true",
  "Specify use of dedicated vertex cache"
>;

def FeatureCaymanISA : SubtargetFeature<"caymanISA",
  "CaymanISA",
  "true",
  "Use Cayman ISA"
>;

def FeatureCFALUBug : SubtargetFeature<"cfalubug",
  "CFALUBug",
  "true",
  "GPU has CF_ALU bug"
>;

def FeatureFlatAddressSpace : SubtargetFeature<"flat-address-space",
  "FlatAddressSpace",
  "true",
  "Support flat address space"
>;

def FeatureUnalignedBufferAccess : SubtargetFeature<"unaligned-buffer-access",
  "UnalignedBufferAccess",
  "true",
  "Support unaligned global loads and stores"
>;

def FeatureTrapHandler: SubtargetFeature<"trap-handler",
  "TrapHandler",
  "true",
  "Trap handler support"
>;

def FeatureUnalignedScratchAccess : SubtargetFeature<"unaligned-scratch-access",
  "UnalignedScratchAccess",
  "true",
  "Support unaligned scratch loads and stores"
>;

def FeatureApertureRegs : SubtargetFeature<"aperture-regs",
  "HasApertureRegs",
  "true",
  "Has Memory Aperture Base and Size Registers"
>;

// XNACK is disabled if SH_MEM_CONFIG.ADDRESS_MODE = GPUVM on chips that support
// XNACK. The current default kernel driver setting is:
// - graphics ring: XNACK disabled
// - compute ring: XNACK enabled
//
// If XNACK is enabled, the VMEM latency can be worse.
// If XNACK is disabled, the 2 SGPRs can be used for general purposes.
def FeatureXNACK : SubtargetFeature<"xnack",
  "EnableXNACK",
  "true",
  "Enable XNACK support"
>;

def FeatureSGPRInitBug : SubtargetFeature<"sgpr-init-bug",
  "SGPRInitBug",
  "true",
  "VI SGPR initilization bug requiring a fixed SGPR allocation size"
>;

class SubtargetFeatureFetchLimit <string Value> :
                          SubtargetFeature <"fetch"#Value,
  "TexVTXClauseSize",
  Value,
  "Limit the maximum number of fetches in a clause to "#Value
>;

def FeatureFetchLimit8 : SubtargetFeatureFetchLimit <"8">;
def FeatureFetchLimit16 : SubtargetFeatureFetchLimit <"16">;

class SubtargetFeatureWavefrontSize <int Value> : SubtargetFeature<
  "wavefrontsize"#Value,
  "WavefrontSize",
  !cast<string>(Value),
  "The number of threads per wavefront"
>;

def FeatureWavefrontSize16 : SubtargetFeatureWavefrontSize<16>;
def FeatureWavefrontSize32 : SubtargetFeatureWavefrontSize<32>;
def FeatureWavefrontSize64 : SubtargetFeatureWavefrontSize<64>;

class SubtargetFeatureLDSBankCount <int Value> : SubtargetFeature <
  "ldsbankcount"#Value,
  "LDSBankCount",
  !cast<string>(Value),
  "The number of LDS banks per compute unit."
>;

def FeatureLDSBankCount16 : SubtargetFeatureLDSBankCount<16>;
def FeatureLDSBankCount32 : SubtargetFeatureLDSBankCount<32>;

class SubtargetFeatureLocalMemorySize <int Value> : SubtargetFeature<
  "localmemorysize"#Value,
  "LocalMemorySize",
  !cast<string>(Value),
  "The size of local memory in bytes"
>;

def FeatureGCN : SubtargetFeature<"gcn",
  "IsGCN",
  "true",
  "GCN or newer GPU"
>;

def FeatureGCN1Encoding : SubtargetFeature<"gcn1-encoding",
  "GCN1Encoding",
  "true",
  "Encoding format for SI and CI"
>;

def FeatureGCN3Encoding : SubtargetFeature<"gcn3-encoding",
  "GCN3Encoding",
  "true",
  "Encoding format for VI"
>;

def FeatureCIInsts : SubtargetFeature<"ci-insts",
  "CIInsts",
  "true",
  "Additional intstructions for CI+"
>;

def FeatureGFX9Insts : SubtargetFeature<"gfx9-insts",
  "GFX9Insts",
  "true",
  "Additional intstructions for GFX9+"
>;

def FeatureSMemRealTime : SubtargetFeature<"s-memrealtime",
  "HasSMemRealTime",
  "true",
  "Has s_memrealtime instruction"
>;

def FeatureInv2PiInlineImm : SubtargetFeature<"inv-2pi-inline-imm",
  "HasInv2PiInlineImm",
  "true",
  "Has 1 / (2 * pi) as inline immediate"
>;

def Feature16BitInsts : SubtargetFeature<"16-bit-insts",
  "Has16BitInsts",
  "true",
  "Has i16/f16 instructions"
>;

def FeatureMovrel : SubtargetFeature<"movrel",
  "HasMovrel",
  "true",
  "Has v_movrel*_b32 instructions"
>;

def FeatureVGPRIndexMode : SubtargetFeature<"vgpr-index-mode",
  "HasVGPRIndexMode",
  "true",
  "Has VGPR mode register indexing"
>;

def FeatureScalarStores : SubtargetFeature<"scalar-stores",
  "HasScalarStores",
  "true",
  "Has store scalar memory instructions"
>;

def FeatureSDWA : SubtargetFeature<"sdwa",
  "HasSDWA",
  "true",
  "Support SDWA (Sub-DWORD Addressing) extension"
>;

def FeatureDPP : SubtargetFeature<"dpp",
  "HasDPP",
  "true",
  "Support DPP (Data Parallel Primitives) extension"
>;

//===------------------------------------------------------------===//
// Subtarget Features (options and debugging)
//===------------------------------------------------------------===//

// Some instructions do not support denormals despite this flag. Using
// fp32 denormals also causes instructions to run at the double
// precision rate for the device.
def FeatureFP32Denormals : SubtargetFeature<"fp32-denormals",
  "FP32Denormals",
  "true",
  "Enable single precision denormal handling"
>;

// Denormal handling for fp64 and fp16 is controlled by the same
// config register when fp16 supported.
// TODO: Do we need a separate f16 setting when not legal?
def FeatureFP64FP16Denormals : SubtargetFeature<"fp64-fp16-denormals",
  "FP64FP16Denormals",
  "true",
  "Enable double and half precision denormal handling",
  [FeatureFP64]
>;

def FeatureFP64Denormals : SubtargetFeature<"fp64-denormals",
  "FP64FP16Denormals",
  "true",
  "Enable double and half precision denormal handling",
  [FeatureFP64, FeatureFP64FP16Denormals]
>;

def FeatureFP16Denormals : SubtargetFeature<"fp16-denormals",
  "FP64FP16Denormals",
  "true",
  "Enable half precision denormal handling",
  [FeatureFP64FP16Denormals]
>;

def FeatureFPExceptions : SubtargetFeature<"fp-exceptions",
  "FPExceptions",
  "true",
  "Enable floating point exceptions"
>;

class FeatureMaxPrivateElementSize<int size> : SubtargetFeature<
  "max-private-element-size-"#size,
  "MaxPrivateElementSize",
  !cast<string>(size),
  "Maximum private access size may be "#size
>;

def FeatureMaxPrivateElementSize4 : FeatureMaxPrivateElementSize<4>;
def FeatureMaxPrivateElementSize8 : FeatureMaxPrivateElementSize<8>;
def FeatureMaxPrivateElementSize16 : FeatureMaxPrivateElementSize<16>;

def FeatureVGPRSpilling : SubtargetFeature<"vgpr-spilling",
  "EnableVGPRSpilling",
  "true",
  "Enable spilling of VGPRs to scratch memory"
>;

def FeatureDumpCode : SubtargetFeature <"DumpCode",
  "DumpCode",
  "true",
  "Dump MachineInstrs in the CodeEmitter"
>;

def FeatureDumpCodeLower : SubtargetFeature <"dumpcode",
  "DumpCode",
  "true",
  "Dump MachineInstrs in the CodeEmitter"
>;

def FeaturePromoteAlloca : SubtargetFeature <"promote-alloca",
  "EnablePromoteAlloca",
  "true",
  "Enable promote alloca pass"
>;

// XXX - This should probably be removed once enabled by default
def FeatureEnableLoadStoreOpt : SubtargetFeature <"load-store-opt",
  "EnableLoadStoreOpt",
  "true",
  "Enable SI load/store optimizer pass"
>;

// Performance debugging feature. Allow using DS instruction immediate
// offsets even if the base pointer can't be proven to be base. On SI,
// base pointer values that won't give the same result as a 16-bit add
// are not safe to fold, but this will override the conservative test
// for the base pointer.
def FeatureEnableUnsafeDSOffsetFolding : SubtargetFeature <
  "unsafe-ds-offset-folding",
  "EnableUnsafeDSOffsetFolding",
  "true",
  "Force using DS instruction immediate offsets on SI"
>;

def FeatureEnableSIScheduler : SubtargetFeature<"si-scheduler",
  "EnableSIScheduler",
  "true",
  "Enable SI Machine Scheduler"
>;

// Unless +-flat-for-global is specified, turn on FlatForGlobal for
// all OS-es on VI and newer hardware to avoid assertion failures due
// to missing ADDR64 variants of MUBUF instructions.
// FIXME: moveToVALU should be able to handle converting addr64 MUBUF
// instructions.

def FeatureFlatForGlobal : SubtargetFeature<"flat-for-global",
  "FlatForGlobal",
  "true",
  "Force to generate flat instruction for global"
>;

// Dummy feature used to disable assembler instructions.
def FeatureDisable : SubtargetFeature<"",
  "FeatureDisable","true",
  "Dummy feature to disable assembler instructions"
>;

class SubtargetFeatureGeneration <string Value,
                                  list<SubtargetFeature> Implies> :
        SubtargetFeature <Value, "Gen", "AMDGPUSubtarget::"#Value,
                          Value#" GPU generation", Implies>;

def FeatureLocalMemorySize0 : SubtargetFeatureLocalMemorySize<0>;
def FeatureLocalMemorySize32768 : SubtargetFeatureLocalMemorySize<32768>;
def FeatureLocalMemorySize65536 : SubtargetFeatureLocalMemorySize<65536>;

def FeatureR600 : SubtargetFeatureGeneration<"R600",
  [FeatureR600ALUInst, FeatureFetchLimit8, FeatureLocalMemorySize0]
>;

def FeatureR700 : SubtargetFeatureGeneration<"R700",
  [FeatureFetchLimit16, FeatureLocalMemorySize0]
>;

def FeatureEvergreen : SubtargetFeatureGeneration<"EVERGREEN",
  [FeatureFetchLimit16, FeatureLocalMemorySize32768]
>;

def FeatureNorthernIslands : SubtargetFeatureGeneration<"NORTHERN_ISLANDS",
  [FeatureFetchLimit16, FeatureWavefrontSize64,
   FeatureLocalMemorySize32768]
>;

def FeatureSouthernIslands : SubtargetFeatureGeneration<"SOUTHERN_ISLANDS",
  [FeatureFP64, FeatureLocalMemorySize32768,
  FeatureWavefrontSize64, FeatureGCN, FeatureGCN1Encoding,
  FeatureLDSBankCount32, FeatureMovrel]
>;

def FeatureSeaIslands : SubtargetFeatureGeneration<"SEA_ISLANDS",
  [FeatureFP64, FeatureLocalMemorySize65536,
  FeatureWavefrontSize64, FeatureGCN, FeatureFlatAddressSpace,
  FeatureGCN1Encoding, FeatureCIInsts, FeatureMovrel]
>;

def FeatureVolcanicIslands : SubtargetFeatureGeneration<"VOLCANIC_ISLANDS",
  [FeatureFP64, FeatureLocalMemorySize65536,
   FeatureWavefrontSize64, FeatureFlatAddressSpace, FeatureGCN,
   FeatureGCN3Encoding, FeatureCIInsts, Feature16BitInsts,
   FeatureSMemRealTime, FeatureVGPRIndexMode, FeatureMovrel,
   FeatureScalarStores, FeatureInv2PiInlineImm, FeatureSDWA,
   FeatureDPP
  ]
>;

def FeatureGFX9 : SubtargetFeatureGeneration<"GFX9",
  [FeatureFP64, FeatureLocalMemorySize65536,
   FeatureWavefrontSize64, FeatureFlatAddressSpace, FeatureGCN,
   FeatureGCN3Encoding, FeatureCIInsts, Feature16BitInsts,
   FeatureSMemRealTime, FeatureScalarStores, FeatureInv2PiInlineImm,
   FeatureApertureRegs, FeatureGFX9Insts
  ]
>;

class SubtargetFeatureISAVersion <int Major, int Minor, int Stepping,
                                  list<SubtargetFeature> Implies>
                                 : SubtargetFeature <
  "isaver"#Major#"."#Minor#"."#Stepping,
  "IsaVersion",
  "ISAVersion"#Major#"_"#Minor#"_"#Stepping,
  "Instruction set version number",
  Implies
>;

def FeatureISAVersion7_0_0 : SubtargetFeatureISAVersion <7,0,0,
  [FeatureSeaIslands,
   FeatureLDSBankCount32]>;

def FeatureISAVersion7_0_1 : SubtargetFeatureISAVersion <7,0,1,
  [FeatureSeaIslands,
   HalfRate64Ops,
   FeatureLDSBankCount32,
   FeatureFastFMAF32]>;

def FeatureISAVersion7_0_2 : SubtargetFeatureISAVersion <7,0,2,
  [FeatureSeaIslands,
   FeatureLDSBankCount16]>;

def FeatureISAVersion8_0_0 : SubtargetFeatureISAVersion <8,0,0,
  [FeatureVolcanicIslands,
   FeatureLDSBankCount32,
   FeatureSGPRInitBug]>;

def FeatureISAVersion8_0_1 : SubtargetFeatureISAVersion <8,0,1,
  [FeatureVolcanicIslands,
   FeatureLDSBankCount32,
   FeatureXNACK]>;

def FeatureISAVersion8_0_2 : SubtargetFeatureISAVersion <8,0,2,
  [FeatureVolcanicIslands,
   FeatureLDSBankCount32,
   FeatureSGPRInitBug]>;

def FeatureISAVersion8_0_3 : SubtargetFeatureISAVersion <8,0,3,
  [FeatureVolcanicIslands,
   FeatureLDSBankCount32]>;

def FeatureISAVersion8_0_4 : SubtargetFeatureISAVersion <8,0,4,
  [FeatureVolcanicIslands,
   FeatureLDSBankCount32]>;

def FeatureISAVersion8_1_0 : SubtargetFeatureISAVersion <8,1,0,
  [FeatureVolcanicIslands,
   FeatureLDSBankCount16,
   FeatureXNACK]>;

def FeatureISAVersion9_0_0 : SubtargetFeatureISAVersion <9,0,0,[]>;
def FeatureISAVersion9_0_1 : SubtargetFeatureISAVersion <9,0,1,[]>;

//===----------------------------------------------------------------------===//
// Debugger related subtarget features.
//===----------------------------------------------------------------------===//

def FeatureDebuggerInsertNops : SubtargetFeature<
  "amdgpu-debugger-insert-nops",
  "DebuggerInsertNops",
  "true",
  "Insert one nop instruction for each high level source statement"
>;

def FeatureDebuggerReserveRegs : SubtargetFeature<
  "amdgpu-debugger-reserve-regs",
  "DebuggerReserveRegs",
  "true",
  "Reserve registers for debugger usage"
>;

def FeatureDebuggerEmitPrologue : SubtargetFeature<
  "amdgpu-debugger-emit-prologue",
  "DebuggerEmitPrologue",
  "true",
  "Emit debugger prologue"
>;

//===----------------------------------------------------------------------===//

def AMDGPUInstrInfo : InstrInfo {
  let guessInstructionProperties = 1;
  let noNamedPositionallyEncodedOperands = 1;
}

def AMDGPUAsmParser : AsmParser {
  // Some of the R600 registers have the same name, so this crashes.
  // For example T0_XYZW and T0_XY both have the asm name T0.
  let ShouldEmitMatchRegisterName = 0;
}

def AMDGPUAsmWriter : AsmWriter {
  int PassSubtarget = 1;
}

def AMDGPUAsmVariants {
  string Default = "Default";
  int Default_ID = 0;
  string VOP3 = "VOP3";
  int VOP3_ID = 1;
  string SDWA = "SDWA";
  int SDWA_ID = 2;
  string DPP = "DPP";
  int DPP_ID = 3;
  string Disable = "Disable";
  int Disable_ID = 4;
}

def DefaultAMDGPUAsmParserVariant : AsmParserVariant {
  let Variant = AMDGPUAsmVariants.Default_ID;
  let Name = AMDGPUAsmVariants.Default;
}

def VOP3AsmParserVariant : AsmParserVariant {
  let Variant = AMDGPUAsmVariants.VOP3_ID;
  let Name = AMDGPUAsmVariants.VOP3;
}

def SDWAAsmParserVariant : AsmParserVariant {
  let Variant = AMDGPUAsmVariants.SDWA_ID;
  let Name = AMDGPUAsmVariants.SDWA;
}

def DPPAsmParserVariant : AsmParserVariant {
  let Variant = AMDGPUAsmVariants.DPP_ID;
  let Name = AMDGPUAsmVariants.DPP;
}

def AMDGPU : Target {
  // Pull in Instruction Info:
  let InstructionSet = AMDGPUInstrInfo;
  let AssemblyParsers = [AMDGPUAsmParser];
  let AssemblyParserVariants = [DefaultAMDGPUAsmParserVariant,
                                VOP3AsmParserVariant,
                                SDWAAsmParserVariant,
                                DPPAsmParserVariant];
  let AssemblyWriters = [AMDGPUAsmWriter];
}

// Dummy Instruction itineraries for pseudo instructions
def ALU_NULL : FuncUnit;
def NullALU : InstrItinClass;

//===----------------------------------------------------------------------===//
// Predicate helper class
//===----------------------------------------------------------------------===//

def TruePredicate : Predicate<"true">;

def isSICI : Predicate<
  "Subtarget->getGeneration() == AMDGPUSubtarget::SOUTHERN_ISLANDS ||"
  "Subtarget->getGeneration() == AMDGPUSubtarget::SEA_ISLANDS"
>, AssemblerPredicate<"FeatureGCN1Encoding">;

def isVI : Predicate <
  "Subtarget->getGeneration() >= AMDGPUSubtarget::VOLCANIC_ISLANDS">,
  AssemblerPredicate<"FeatureGCN3Encoding">;

def isGFX9 : Predicate <
  "Subtarget->getGeneration() >= AMDGPUSubtarget::GFX9">,
  AssemblerPredicate<"FeatureGFX9Insts">;

// TODO: Either the name to be changed or we simply use IsCI!
def isCIVI : Predicate <
  "Subtarget->getGeneration() >= AMDGPUSubtarget::SEA_ISLANDS">,
  AssemblerPredicate<"FeatureCIInsts">;

def HasFlatAddressSpace : Predicate<"Subtarget->hasFlatAddressSpace()">;

def Has16BitInsts : Predicate<"Subtarget->has16BitInsts()">;

def HasSDWA : Predicate<"Subtarget->hasSDWA()">,
  AssemblerPredicate<"FeatureSDWA">;

def HasDPP : Predicate<"Subtarget->hasDPP()">,
  AssemblerPredicate<"FeatureDPP">;

class PredicateControl {
  Predicate SubtargetPredicate;
  Predicate SIAssemblerPredicate = isSICI;
  Predicate VIAssemblerPredicate = isVI;
  list<Predicate> AssemblerPredicates = [];
  Predicate AssemblerPredicate = TruePredicate;
  list<Predicate> OtherPredicates = [];
  list<Predicate> Predicates = !listconcat([SubtargetPredicate, AssemblerPredicate],
                                            AssemblerPredicates,
                                            OtherPredicates);
}

// Include AMDGPU TD files
include "R600Schedule.td"
include "SISchedule.td"
include "Processors.td"
include "AMDGPUInstrInfo.td"
include "AMDGPUIntrinsics.td"
include "AMDGPURegisterInfo.td"
include "AMDGPURegisterBanks.td"
include "AMDGPUInstructions.td"
include "AMDGPUCallingConv.td"
