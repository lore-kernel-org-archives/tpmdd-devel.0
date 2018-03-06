From: Jeremy Cline <jeremy@jcline.org>
Subject: Regression from efi: call get_event_log before ExitBootServices
Date: Tue, 6 Mar 2018 16:00:53 +0000
Message-ID: <01000161fc0b4755-df0621f4-ab5d-479a-b425-adf98427a308-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thiebaud Weksteen <tweek@google.com>, Javier Martinez Canillas <javierm@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-efi@vger.kernel.org, linux-integrity@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

Hi folks,

Commit 33b6d03469b2 ("efi: call get_event_log before ExitBootServices")
causes my GP-electronic T701 tablet to hang when booting. Reverting the
patch series or hiding the TPM in the BIOS fixes the problem.

I've never fiddled with TPMs before so I'm not sure what what debugging
information to provide. It's got an Atom Z3735G and the UEFI firmware is
InsydeH20 version BYT70A.YNCHENG.WIN.007.


Regards,
Jeremy
