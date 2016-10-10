From: Genki Marshall <genki@genki.is>
Subject: Suspend/Resume issue in 4.8-rc8
Date: Mon, 10 Oct 2016 02:36:43 -0400
Message-ID: <147608140340.2733.12285605928656228981@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

  Hello,

On 4.8-rc8, I'm having an issue with laptop suspend/resume for the
Chromebook Pixel (2015). Specifically:

When on commit 24532f7 on Linus's tree (latest commit at time of
writing) I'm having the following issue happen consistently:

1. Close lid.
2. Wait for CPU to wind down and laptop lid's light to go off.
3. Open lid.
4. Observe that the computer is booting from scratch.

I noticed that 4.8-rc7 was working fine. Bisecting, I found 0c54133 to
be the commit at which this issue starts happening, which is a
patch to drivers/char/tpm/tpm-interface.c .

I confirmed this is still relevant as I can proceed to checkout
24532f7 again, do a git revert 0c54133, recompile, and the issue no
longer happens.

It's a very small patch. Looking through the code, it's strange, as it
seems to use the tpm_pcr_read_dev() helper correctly (to my totally
untrained eye).

In the version with 0c54133 _reverted_, when I make the values of 'rc'
be printed, recompile, and then resume my laptop (which again, it does
successfully), I see the values go like:

  rc =3D tpm_transmit(chip, (u8 *) &cmd, READ_PCR_RESULT_SIZE, 0);
  /* rc =3D=3D 30 here */
  ...
  rc =3D be32_to_cpu(cmd.header.out.return_code);
  /* rc =3D=3D 0 here */

So it returns 0 correctly as expected. But tpm_transmit_cmd() looks
like it should do effectively the same thing (calling tpm_transmit()
then calling be32_to_cpu()), and it would just be that rc =3D=3D 0 right
away. It started to be difficult to debug as I can't see the results
of prints when resuming on the broken tree (as it goes straight to
rebooting).

Anyway, I was advised on #kernel-newbies that at this point it would
be best to just email in like this. Let me know if it would be helpful
for me to answer/test anything.

  Genki
