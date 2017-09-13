From: Thiebaud Weksteen via tpmdd-devel <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: Re: [PATCH v2 2/3] efi: call get_event_log before
 ExitBootServices
Date: Wed, 13 Sep 2017 18:28:06 +0200
Message-ID: <CA+zpnLe9PvqaU4QM9W_YBZQiQFVMVA7q41nsS2NJa3Ly0qOeHQ@mail.gmail.com>
References: <20170911100022.7251-3-tweek@google.com>
 <201709132252.uZyTCtDz%fengguang.wu@intel.com>
Reply-To: Thiebaud Weksteen <tweek-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4881742885870445994=="
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <201709132252.uZyTCtDz%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

--===============4881742885870445994==
Content-Type: multipart/alternative; boundary="94eb2c060ade42bb8c055914a6e3"

--94eb2c060ade42bb8c055914a6e3
Content-Type: text/plain; charset="UTF-8"

efi_tpm_eventlog_init should be in patch 0003 and not 0002.
I'll send a new version of the patch set once I've received more feedback.

On Wed, Sep 13, 2017 at 4:49 PM, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> Hi Thiebaud,
>
> [auto build test ERROR on efi/next]
> [also build test ERROR on next-20170913]
> [cannot apply to char-misc/char-misc-testing linus/master v4.13]
> [if your patch is applied to the wrong git tree, please drop us a note to
> help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Thiebaud-
> Weksteen/Call-GetEventLog-before-ExitBootServices/20170913-221312
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git next
> config: ia64-allmodconfig (attached as .config)
> compiler: ia64-linux-gcc (GCC) 6.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/
> sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=ia64
>
> Note: the linux-review/Thiebaud-Weksteen/Call-GetEventLog-
> before-ExitBootServices/20170913-221312 HEAD
> 58dc8ee5de3bb5fb1ef216b80a76102d2de2b141 builds fine.
>       It only hurts bisectibility.
>
> All errors (new ones prefixed by >>):
>
>    drivers/firmware/efi/tpm.c: In function 'efi_tpm_eventlog_init':
> >> drivers/firmware/efi/tpm.c:24:9: error: 'struct efi' has no member
> named 'tpm_log'
>      if (efi.tpm_log == EFI_INVALID_TABLE_ADDR)
>             ^
>    In file included from arch/ia64/include/asm/io.h:23:0,
>                     from arch/ia64/include/asm/smp.h:20,
>                     from include/linux/smp.h:59,
>                     from include/linux/percpu.h:6,
>                     from include/linux/percpu-rwsem.h:6,
>                     from include/linux/fs.h:32,
>                     from include/linux/proc_fs.h:8,
>                     from include/linux/efi.h:18,
>                     from drivers/firmware/efi/tpm.c:10:
>    drivers/firmware/efi/tpm.c:27:26: error: 'struct efi' has no member
> named 'tpm_log'
>      tbl = early_memremap(efi.tpm_log, sizeof(*tbl));
>                              ^
>    arch/ia64/include/asm/early_ioremap.h:5:62: note: in definition of
> macro 'early_memremap'
>     #define early_memremap(phys_addr, size)
> early_ioremap(phys_addr, size)
>                                                                  ^~~~~~~~~
>    In file included from include/linux/kernel.h:13:0,
>                     from include/linux/list.h:8,
>                     from include/linux/preempt.h:10,
>                     from include/linux/spinlock.h:50,
>                     from include/linux/seqlock.h:35,
>                     from include/linux/time.h:5,
>                     from include/linux/efi.h:16,
>                     from drivers/firmware/efi/tpm.c:10:
>    drivers/firmware/efi/tpm.c:30:7: error: 'struct efi' has no member
> named 'tpm_log'
>        efi.tpm_log);
>           ^
>    include/linux/printk.h:301:33: note: in definition of macro 'pr_err'
>      printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
>                                     ^~~~~~~~~~~
>    drivers/firmware/efi/tpm.c:35:22: error: 'struct efi' has no member
> named 'tpm_log'
>      memblock_reserve(efi.tpm_log, tbl_size);
>                          ^
>
> vim +24 drivers/firmware/efi/tpm.c
>
>     15
>     16  /*
>     17   * Reserve the memory associated with the TPM Event Log
> configuration table.
>     18   */
>     19  int __init efi_tpm_eventlog_init(void)
>     20  {
>     21          struct linux_efi_tpm_eventlog *tbl;
>     22          unsigned int tbl_size;
>     23
>   > 24          if (efi.tpm_log == EFI_INVALID_TABLE_ADDR)
>     25                  return 0;
>     26
>     27          tbl = early_memremap(efi.tpm_log, sizeof(*tbl));
>     28          if (!tbl) {
>     29                  pr_err("Failed to map TPM Event Log table @
> 0x%lx\n",
>     30                          efi.tpm_log);
>     31                  return -ENOMEM;
>     32          }
>     33
>     34          tbl_size = sizeof(*tbl) + tbl->size;
>     35          memblock_reserve(efi.tpm_log, tbl_size);
>     36          early_memunmap(tbl, sizeof(*tbl));
>     37          return 0;
>     38  }
>     39
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology
> Center
> https://lists.01.org/pipermail/kbuild-all                   Intel
> Corporation
>

--94eb2c060ade42bb8c055914a6e3
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">efi_tpm_eventlog_init should be in patch 0003 and not 0002=
.=C2=A0<div>I&#39;ll send a new version of the patch set once I&#39;ve rece=
ived more feedback.</div></div><div class=3D"gmail_extra"><br><div class=3D=
"gmail_quote">On Wed, Sep 13, 2017 at 4:49 PM, kbuild test robot <span dir=
=3D"ltr">&lt;<a href=3D"mailto:lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" target=3D"_blank">lkp@intel.c=
om</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"marg=
in:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">Hi Thiebaud,<br>
<br>
[auto build test ERROR on efi/next]<br>
[also build test ERROR on next-20170913]<br>
[cannot apply to char-misc/char-misc-testing linus/master v4.13]<br>
[if your patch is applied to the wrong git tree, please drop us a note to h=
elp improve the system]<br>
<br>
url:=C2=A0 =C2=A0 <a href=3D"https://github.com/0day-ci/linux/commits/Thieb=
aud-Weksteen/Call-GetEventLog-before-ExitBootServices/20170913-221312" rel=
=3D"noreferrer" target=3D"_blank">https://github.com/0day-ci/<wbr>linux/com=
mits/Thiebaud-<wbr>Weksteen/Call-GetEventLog-<wbr>before-ExitBootServices/<=
wbr>20170913-221312</a><br>
base:=C2=A0 =C2=A0<a href=3D"https://git.kernel.org/pub/scm/linux/kernel/gi=
t/efi/efi.git" rel=3D"noreferrer" target=3D"_blank">https://git.kernel.org/=
pub/<wbr>scm/linux/kernel/git/efi/efi.<wbr>git</a> next<br>
config: ia64-allmodconfig (attached as .config)<br>
compiler: ia64-linux-gcc (GCC) 6.2.0<br>
reproduce:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 wget <a href=3D"https://raw.githubusercontent.c=
om/intel/lkp-tests/master/sbin/make.cross" rel=3D"noreferrer" target=3D"_bl=
ank">https://raw.githubusercontent.<wbr>com/intel/lkp-tests/master/<wbr>sbi=
n/make.cross</a> -O ~/bin/make.cross<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 chmod +x ~/bin/make.cross<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 # save the attached .config to linux build tree=
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 make.cross ARCH=3Dia64<br>
<br>
Note: the linux-review/Thiebaud-<wbr>Weksteen/Call-GetEventLog-<wbr>before-=
ExitBootServices/<wbr>20170913-221312 HEAD 58dc8ee5de3bb5fb1ef216b80a7610<w=
br>2d2de2b141 builds fine.<br>
=C2=A0 =C2=A0 =C2=A0 It only hurts bisectibility.<br>
<br>
All errors (new ones prefixed by &gt;&gt;):<br>
<br>
=C2=A0 =C2=A0drivers/firmware/efi/tpm.c: In function &#39;efi_tpm_eventlog_=
init&#39;:<br>
&gt;&gt; drivers/firmware/efi/tpm.c:24:<wbr>9: error: &#39;struct efi&#39; =
has no member named &#39;tpm_log&#39;<br>
=C2=A0 =C2=A0 =C2=A0if (efi.tpm_log =3D=3D EFI_INVALID_TABLE_ADDR)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^<br>
=C2=A0 =C2=A0In file included from arch/ia64/include/asm/io.h:23:<wbr>0,<br=
>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
arch/ia64/include/asm/smp.h:<wbr>20,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/smp.h:59,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/percpu.h:6,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/percpu-rwsem.h:<wbr>6,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/fs.h:32,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/proc_fs.h:8,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/efi.h:18,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
drivers/firmware/efi/tpm.c:10:<br>
=C2=A0 =C2=A0drivers/firmware/efi/tpm.c:27:<wbr>26: error: &#39;struct efi&=
#39; has no member named &#39;tpm_log&#39;<br>
=C2=A0 =C2=A0 =C2=A0tbl =3D early_memremap(efi.tpm_log, sizeof(*tbl));<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^<br>
=C2=A0 =C2=A0arch/ia64/include/asm/early_<wbr>ioremap.h:5:62: note: in defi=
nition of macro &#39;early_memremap&#39;<br>
=C2=A0 =C2=A0 #define early_memremap(phys_addr, size)=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 early_ioremap(phys_addr, size)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0^~~~~~~~~<br>
=C2=A0 =C2=A0In file included from include/linux/kernel.h:13:0,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/list.h:8,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/preempt.h:10,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/spinlock.h:50,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/seqlock.h:35,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/time.h:5,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
include/linux/efi.h:16,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 from =
drivers/firmware/efi/tpm.c:10:<br>
=C2=A0 =C2=A0drivers/firmware/efi/tpm.c:30:<wbr>7: error: &#39;struct efi&#=
39; has no member named &#39;tpm_log&#39;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0efi.tpm_log);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^<br>
=C2=A0 =C2=A0include/linux/printk.h:301:33: note: in definition of macro &#=
39;pr_err&#39;<br>
=C2=A0 =C2=A0 =C2=A0printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^~~~~~~~~~~<br>
=C2=A0 =C2=A0drivers/firmware/efi/tpm.c:35:<wbr>22: error: &#39;struct efi&=
#39; has no member named &#39;tpm_log&#39;<br>
=C2=A0 =C2=A0 =C2=A0memblock_reserve(efi.tpm_log, tbl_size);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0^<br>
<br>
vim +24 drivers/firmware/efi/tpm.c<br>
<br>
=C2=A0 =C2=A0 15<br>
=C2=A0 =C2=A0 16=C2=A0 /*<br>
=C2=A0 =C2=A0 17=C2=A0 =C2=A0* Reserve the memory associated with the TPM E=
vent Log configuration table.<br>
=C2=A0 =C2=A0 18=C2=A0 =C2=A0*/<br>
=C2=A0 =C2=A0 19=C2=A0 int __init efi_tpm_eventlog_init(void)<br>
=C2=A0 =C2=A0 20=C2=A0 {<br>
=C2=A0 =C2=A0 21=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct linux_efi_tpm_eve=
ntlog *tbl;<br>
=C2=A0 =C2=A0 22=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned int tbl_size;<b=
r>
=C2=A0 =C2=A0 23<br>
=C2=A0 &gt; 24=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (efi.tpm_log =3D=3D EFI=
_INVALID_TABLE_ADDR)<br>
=C2=A0 =C2=A0 25=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return 0;<br>
=C2=A0 =C2=A0 26<br>
=C2=A0 =C2=A0 27=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tbl =3D early_memremap(e=
fi.tpm_log, sizeof(*tbl));<br>
=C2=A0 =C2=A0 28=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!tbl) {<br>
=C2=A0 =C2=A0 29=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 pr_err(&quot;Failed to map TPM Event Log table @ 0x%lx\n&quot;,<br>
=C2=A0 =C2=A0 30=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 efi.tpm_log);<br>
=C2=A0 =C2=A0 31=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return -ENOMEM;<br>
=C2=A0 =C2=A0 32=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
=C2=A0 =C2=A0 33<br>
=C2=A0 =C2=A0 34=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tbl_size =3D sizeof(*tbl=
) + tbl-&gt;size;<br>
=C2=A0 =C2=A0 35=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 memblock_reserve(efi.tpm=
_log, tbl_size);<br>
=C2=A0 =C2=A0 36=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 early_memunmap(tbl, size=
of(*tbl));<br>
=C2=A0 =C2=A0 37=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
=C2=A0 =C2=A0 38=C2=A0 }<br>
=C2=A0 =C2=A0 39<br>
<br>
---<br>
0-DAY kernel test infrastructure=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 Open Source Technology Center<br>
<a href=3D"https://lists.01.org/pipermail/kbuild-all" rel=3D"noreferrer" ta=
rget=3D"_blank">https://lists.01.org/<wbr>pipermail/kbuild-all</a>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Intel Corpora=
tion<br>
</blockquote></div><br></div>

--94eb2c060ade42bb8c055914a6e3--


--===============4881742885870445994==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
--===============4881742885870445994==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
tpmdd-devel mailing list
tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--===============4881742885870445994==--
