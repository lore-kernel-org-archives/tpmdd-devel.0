From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v6 11/11] A test program for vTPM
 devicecreation
Date: Fri, 11 Mar 2016 08:16:28 -0500
Message-ID: <56E2C52C.20606@linux.vnet.ibm.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
	<1457545170-30120-12-git-send-email-stefanb@linux.vnet.ibm.com>
	<201603102058.u2AKw7Ie013400@d01av04.pok.ibm.com>
	<20160311103001.GA13368@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20160311103001.GA13368-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Stefan Berger <stefanb-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 03/11/2016 05:30 AM, Jarkko Sakkinen wrote:
> On Thu, Mar 10, 2016 at 03:57:58PM -0500, Stefan Berger wrote:
>>     Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote on 03/09/2016 12:39:30
>>     PM:
>>     >
>>     > This patch provides a program that is for testing purposes only.
>>     >
>>     > Build it using the following commands:
>>     >
>>     > make headers_install ARCH=x86_64  INSTALL_HDR_PATH=/usr
>>     >
>>     > gcc vtpmctrl.c -o vtpmctrl
>>     >
>>     > To use it:
>>     >
>>     > To create a device pair and have vtpmctrl listen for commands, display
>>     > them and respond with TPM success messages do:
>>     >
>>     > Created TPM device /dev/tpm0; vTPM device has fd 4, major/minor =
>>     10/224.
>>     >
>>     > In another shell do
>>     >
>>     > 00000000 00 c4 00 00 00 0a 00 00 00 00
>>     > 00000012
>>
>>     This test program is now available as part of a test suite at:
>>
>>     https://github.com/stefanberger/linux-vtpm-tests
> I've ported TPM 2.0 simulator proxy here
>
> git://git.infradead.org/users/jjs/tpm2-scripts.git
>
> At the moment it gets blocked on write() at client side and on read() at
> server side. Haven't yet applied the timeouts patch but I'd expect
> things to work without that patch since it's a separate patch

With this patch applied it works for me. I am using a file descriptor 
rather than the file. If using a file, it seems to want to read more 
bytes to fill up 4096 bytes or get an EOF. Also make sure that /dev/tpmX 
is not a normal file. I ran into that problem when using exec 
100<>/dev/tpm1  that creates /dev/tpm1 as file if it isn't there...

diff --git a/tpm2-simulator-vtpm b/tpm2-simulator-vtpm
index f9f7d82..6a9a0d9 100755
--- a/tpm2-simulator-vtpm
+++ b/tpm2-simulator-vtpm
@@ -56,6 +56,7 @@ class TPM2Simulator():
          """ Initializes the connection to the simulator and 
initializes the
              simulator device by sending some control commands """

+        return
          self.ctrl = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
          self.ctrl.connect((host, 2322))
          self.data = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
@@ -109,16 +110,14 @@ class TPM2Simulator():
          with open('/dev/vtpmx', 'w+b', buffering = 0) as vtpmx_fp:
              ioctl(vtpmx_fp, VTPM_IOC_NEW_DEV, addressof(new_dev))

-            vtpm_fp = os.fdopen(new_dev.fd)
-
              for n, t in new_dev._fields_:
                  print(n, getattr(new_dev, n))

              while True:
-                stream = vtpm_fp.read(4096)
+                stream = os.read(new_dev.fd, 4096)
                  print("IN {}".format(binascii.hexlify(stream)))
-                resp = self.transmit_command(stream)
-                vtpm_fp.write(resp)
+                #resp = self.transmit_command(stream)
+                os.write(new_dev.fd, stream)

  class c_vtpm_new_dev(Structure):
      _fields_ = \


     Stefan


------------------------------------------------------------------------------
Transform Data into Opportunity.
Accelerate data analysis in your applications with
Intel Data Analytics Acceleration Library.
Click to learn more.
http://pubads.g.doubleclick.net/gampad/clk?id=278785111&iu=/4140
